import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notequiz/api.dart';
import 'package:notequiz/widgets.dart';
import 'package:notequiz/screens/explanation.dart';
import 'package:notequiz/screens/input.dart';
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

  Future<void> loadEvidenceFont(WidgetTester t) async {
    await t.runAsync(() async {
      final bytes = await File(Platform.environment['EVIDENCE_FONT']!)
          .readAsBytes();
      await (FontLoader(
        'EvidenceFont',
      )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
      if (Platform.environment['EVIDENCE_ICONS'] != null) {
        final icons = await File(Platform.environment['EVIDENCE_ICONS']!)
            .readAsBytes();
        await (FontLoader(
          'MaterialIcons',
        )..addFont(Future.value(ByteData.sublistView(icons)))).load();
      }
    });
  }

  Future<void> capture(
    WidgetTester t,
    String name,
    Widget screen, {
    Size size = const Size(1280, 800),
    double pixelRatio = 1.5,
    bool settle = true,
  }) async {
    final key = GlobalKey();
    await t.binding.setSurfaceSize(size);
    await t.pumpWidget(
      RepaintBoundary(
        key: key,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'EvidenceFont',
            colorScheme: ColorScheme.fromSeed(seedColor: blue),
            scaffoldBackgroundColor: const Color(0xFFF5F7FC),
          ),
          home: screen,
        ),
      ),
    );
    if (settle) {
      await t.pumpAndSettle();
    } else {
      await t.pump(const Duration(milliseconds: 120));
    }
    expect(t.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    await t.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await File('docs/screenshots/$name.png')
          .writeAsBytes(bytes!.buffer.asUint8List());
    });
  }

  testWidgets('capture common states from real widgets', (t) async {
    await loadEvidenceFont(t);
    for (final name in ['loading', 'error', 'empty']) {
      final state = switch (name) {
        'loading' => const LoadingView(),
        'error' => ErrorView(onRetry: () {}),
        _ => const EmptyView(),
      };
      await capture(
        t,
        '$name-test',
        StudyPage(title: '핵심 요약', child: state),
        size: const Size(390, 844),
        pixelRatio: 2,
        settle: name != 'loading',
      );
    }
    await t.binding.setSurfaceSize(null);
  }, skip: Platform.environment['EVIDENCE_FONT'] == null);

  testWidgets('capture wide screens from real widgets', (t) async {
    await loadEvidenceFont(t);
    await capture(t, 'input-wide', LectureInputScreen(loader: load));
    await capture(t, 'summary-wide', SummaryScreen(loader: load));
    await capture(
      t,
      'quiz-wide',
      QuizScreen(questions: questions, index: 0, loader: load),
    );
    await capture(
      t,
      'explanation-wide',
      ExplanationScreen(
        questions: questions,
        index: 0,
        loader: load,
        selected: '앱 가격',
      ),
    );
    await capture(
      t,
      'explanation-phone-options',
      ExplanationScreen(
        questions: questions,
        index: 0,
        loader: load,
        selected: '앱 가격',
      ),
      size: const Size(390, 844),
      pixelRatio: 2,
    );
    await capture(
      t,
      'result-wide',
      ResultScreen(questions: questions, loader: load),
    );
    await t.binding.setSurfaceSize(null);
  }, skip: Platform.environment['EVIDENCE_FONT'] == null);
}
