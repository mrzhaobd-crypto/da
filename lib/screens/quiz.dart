// Q-1 Text+LinearProgressIndicator 문항 진행 P01; Q-2 OutlinedButton 보기 선택 P04; Q-3 FilledButton 해설 확인 P05
import 'package:flutter/material.dart';

import '../api.dart';
import '../widgets.dart';
import 'explanation.dart';

class QuizLoadScreen extends StatelessWidget {
  const QuizLoadScreen({super.key, required this.loader});
  final Loader loader;
  @override
  Widget build(BuildContext context) => StudyPage(
    title: '복습 퀴즈',
    child: LoadRows(
      resource: 'questions',
      loader: loader,
      builder: (rows) => QuizBody(questions: rows, index: 0, loader: loader),
    ),
  );
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({
    super.key,
    required this.questions,
    required this.index,
    required this.loader,
  });
  final Rows questions;
  final int index;
  final Loader loader;
  @override
  Widget build(BuildContext context) => StudyPage(
    title: '복습 퀴즈',
    child: QuizBody(questions: questions, index: index, loader: loader),
  );
}

class QuizBody extends StatefulWidget {
  const QuizBody({
    super.key,
    required this.questions,
    required this.index,
    required this.loader,
  });
  final Rows questions;
  final int index;
  final Loader loader;
  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  String? selected; // STATE: selected option -> Q-2 highlight only, no grading.
  @override
  Widget build(BuildContext context) {
    final q = widget.questions[widget.index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Q-1 문항 ${widget.index + 1} / ${widget.questions.length} · ${q['type']}',
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (widget.index + 1) / widget.questions.length,
        ),
        const SizedBox(height: 24), // P01 Q-1 display progress, not score
        heading(q['prompt'] as String),
        for (final option in q['options'] as List)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(18),
                backgroundColor: selected == option
                    ? const Color(0xFFDCE4FA)
                    : Colors.white,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () => setState(() => selected = option as String),
              child: Text('${selected == option ? '●' : '○'} $option'),
            ),
          ), // P04 Q-2
        const SizedBox(height: 12),
        FilledButton(
          onPressed: selected == null
              ? null
              : () => push(
                  context,
                  ExplanationScreen(
                    questions: widget.questions,
                    index: widget.index,
                    loader: widget.loader,
                    selected: selected,
                  ),
                ),
          child: const Text('Q-3 정답과 해설 확인'),
        ), // P05 Q-3
      ],
    );
  }
}
