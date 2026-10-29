// E-1 Text 문항 진행 P01; E-2 Container+Text 정답·해설·원래 보기 P04; E-3 Container+Text 강의 근거 P06; E-4 FilledButton 다음 문제 P07
import 'package:flutter/material.dart';

import '../api.dart';
import '../widgets.dart';
import 'quiz.dart';
import 'result.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({
    super.key,
    required this.questions,
    required this.index,
    required this.loader,
    required this.selected,
  });

  final Rows questions;
  final int index;
  final String? selected;
  final Loader loader;

  @override
  Widget build(BuildContext context) {
    final q = questions[index]; // P04 Q 화면과 같은 문항 객체를 그대로 쓴다.
    final options = (q['options'] as List).cast<String>();
    return StudyPage(
      title: '정답과 해설',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('E-1 해설 ${index + 1} / ${questions.length}'),
          const SizedBox(height: 16),
          heading('정답의 이유를 확인하세요'),
          Text(q['prompt'] as String),
          const SizedBox(height: 20),
          panel(
            'E-2 정답: ${q['answer']}',
            q['explanation'] as String,
          ), // P04 E-2
          _OriginalOptions(
            options: options,
            answer: q['answer'] as String,
            selected: selected,
          ), // P04 E-2 원래 보기와 내 선택을 같은 문항에서 표시
          panel(
            'E-3 강의 근거',
            q['source'] as String,
            tinted: true,
          ), // P06 E-3 항상 표시
          FilledButton(
            onPressed: () => push(
              context,
              index + 1 < questions.length
                  ? QuizScreen(
                      questions: questions,
                      index: index + 1,
                      loader: loader,
                    )
                  : ResultScreen(questions: questions, loader: loader),
            ),
            child: Text(
              index + 1 < questions.length ? 'E-4 다음 문제' : 'E-4 예시 결과 보기',
            ),
          ), // P07 E-4 다음 과업으로 이동
        ],
      ),
    );
  }
}

class _OriginalOptions extends StatelessWidget {
  const _OriginalOptions({
    required this.options,
    required this.answer,
    required this.selected,
  });

  final List<String> options;
  final String answer;
  final String? selected;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFDDE2EC)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'E-2 원래 보기',
          style: TextStyle(color: blue, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  option == answer
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: option == answer ? blue : Colors.blueGrey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 18, height: 1.4),
                  ),
                ),
                if (option == answer) const _Badge(label: '정답'),
                if (option == selected) const _Badge(label: '내 선택'),
              ],
            ),
          ),
        if (selected == null)
          const Text(
            '내 선택은 결과 화면에서 다시 들어올 때 표시하지 않습니다.',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
      ],
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(left: 6, top: 2),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFE9EEFC),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        color: blue,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
