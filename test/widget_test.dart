import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notequiz/main.dart';
import 'package:notequiz/api.dart';
import 'package:notequiz/widgets.dart';
import 'package:notequiz/screens/explanation.dart';
import 'package:notequiz/screens/quiz.dart';
import 'package:notequiz/screens/result.dart';
import 'package:notequiz/screens/summary.dart';

void main() {
  final db = jsonDecode(File('mock_server/db.json').readAsStringSync()) as Map;
  final questions = (db['questions'] as List)
      .map((x) => Map<String, dynamic>.from(x as Map))
      .toList();

  Future<Rows> load(String key) async => (db[key] as List)
      .map((x) => Map<String, dynamic>.from(x as Map))
      .toList();

  Future<void> tap(WidgetTester t, String text) async {
    final f = find.text(text);
    await t.ensureVisible(f);
    await t.tap(f);
    await t.pumpAndSettle();
  }

  testWidgets(
    'input validation and complete 3-question flow with fixed result',
    (t) async {
      await t.pumpWidget(NoteQuizApp(loader: load));
      await tap(t, 'I-3 예시 요약 확인');
      expect(find.text('강의 내용을 입력하거나 예시를 불러오세요.'), findsOneWidget);

      await t.enterText(find.byType(TextField), '테스트 강의');
      await t.pump();
      expect(find.text('강의 내용을 입력하거나 예시를 불러오세요.'), findsNothing);

      await tap(t, 'I-2 예시 강의 불러오기');
      await tap(t, 'I-3 예시 요약 확인');
      expect(find.textContaining('S-1 선언형 UI'), findsOneWidget);

      await tap(t, 'S-4 복습 퀴즈 시작');
      final choices = ['○ 앱 가격', '○ O', '○ 실제 결제'];
      for (var i = 0; i < 3; i++) {
        final button = t.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Q-3 정답과 해설 확인'),
        );
        expect(button.onPressed, isNull);
        await tap(t, choices[i]);
        await tap(t, 'Q-3 정답과 해설 확인');
        expect(find.text('E-2 원래 보기'), findsOneWidget);
        expect(find.text('내 선택'), findsOneWidget);
        expect(find.text('E-3 강의 근거'), findsOneWidget);
        expect(
          find.text('E-2 정답: ${db['questions'][i]['answer']}'),
          findsOneWidget,
        );
        await tap(t, i < 2 ? 'E-4 다음 문제' : 'E-4 예시 결과 보기');
      }

      expect(find.text('예시 결과 2 / 3'), findsOneWidget);
      await tap(t, 'R-3 해설 다시 보기');
      expect(find.text('E-3 강의 근거'), findsOneWidget);
      await t.pageBack();
      await t.pumpAndSettle();
      await tap(t, 'R-4 새 강의 입력');
      expect(find.text('I-3 예시 요약 확인'), findsOneWidget);
    },
  );

  for (final kind in ['summary', 'quiz', 'result']) {
    Widget page(Loader loader) => switch (kind) {
      'summary' => SummaryScreen(loader: loader),
      'quiz' => QuizLoadScreen(loader: loader),
      _ => ResultScreen(questions: questions, loader: loader),
    };

    testWidgets('$kind loading empty error retry', (t) async {
      final pending = Completer<Rows>();
      await t.pumpWidget(MaterialApp(home: page((_) => pending.future)));
      await t.pump();
      expect(find.byType(LoadingView), findsOneWidget);

      pending.complete([]);
      await t.pumpAndSettle();
      expect(find.byType(EmptyView), findsOneWidget);

      await t.pumpWidget(const SizedBox());
      var calls = 0;
      await t.pumpWidget(
        MaterialApp(
          home: page((r) async {
            if (calls++ == 0) throw Exception('offline');
            return load(r);
          }),
        ),
      );
      await t.pumpAndSettle();
      expect(find.byType(ErrorView), findsOneWidget);
      await tap(t, '다시 시도');
      expect(find.byType(ErrorView), findsNothing);
      expect(calls, 2);
    });
  }

  testWidgets('320px and 1280px summary have no overflow', (t) async {
    for (final width in [320.0, 1280.0]) {
      await t.binding.setSurfaceSize(Size(width, 900));
      await t.pumpWidget(MaterialApp(home: SummaryScreen(loader: load)));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    }
    await t.binding.setSurfaceSize(null);
  });

  testWidgets('320px empty and explanation screens have no overflow', (
    t,
  ) async {
    await t.binding.setSurfaceSize(const Size(320, 700));

    await t.pumpWidget(
      const MaterialApp(
        home: StudyPage(title: '빈 상태', child: EmptyView()),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('표시할 자료가 없어요'), findsOneWidget);
    expect(t.takeException(), isNull);

    await t.pumpWidget(
      MaterialApp(
        home: ExplanationScreen(
          questions: questions,
          index: 0,
          loader: load,
          selected: '앱 가격',
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('E-2 원래 보기'), findsOneWidget);
    expect(t.takeException(), isNull);

    await t.binding.setSurfaceSize(null);
  });
}
