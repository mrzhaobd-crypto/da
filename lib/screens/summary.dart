// S-1..S-3 Container+Text 주제 요약 P08/P04; S-4 FilledButton 복습 퀴즈 시작 P07
import 'package:flutter/material.dart';

import '../api.dart';
import '../widgets.dart';
import 'quiz.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.loader});
  final Loader loader;
  @override
  Widget build(BuildContext context) => StudyPage(
    title: '핵심 요약',
    child: LoadRows(
      resource: 'topics',
      loader: loader,
      builder: (rows) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading('핵심 개념부터 확인해요'),
          const Text('예시 강의 · 주제별 요약과 근거'),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) => Wrap(
              spacing: 16,
              runSpacing: 0,
              children: [
                for (var i = 0; i < rows.length; i++)
                  SizedBox(
                    width: c.maxWidth >= 720
                        ? (c.maxWidth - 32) / 3
                        : c.maxWidth,
                    child: panel(
                      'S-${i + 1} ${rows[i]['title']}',
                      '${rows[i]['summary']}\n\n근거: ${rows[i]['source']}',
                    ),
                  ),
              ],
            ),
          ), // P04 S-1..3
          FilledButton(
            onPressed: () => push(context, QuizLoadScreen(loader: loader)),
            child: const Text('S-4 복습 퀴즈 시작'),
          ), // P07 S-4
        ],
      ),
    ),
  );
}
