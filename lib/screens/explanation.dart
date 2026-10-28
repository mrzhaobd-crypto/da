// E-1 Text 문항 진행 P01; E-2 Container+Text 정답과 해설 P04; E-3 Container+Text 강의 근거 P06; E-4 FilledButton 다음 문제 P03
import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets.dart';
import 'quiz.dart';
import 'result.dart';
class ExplanationScreen extends StatelessWidget {
 const ExplanationScreen({super.key, required this.questions, required this.index, required this.loader});
 final Rows questions; final int index; final Loader loader;
 @override Widget build(BuildContext context) {
 final q = questions[index]; // P04 use the same object as Q; never maintain a separate answer list.
 return StudyPage(title: '정답과 해설', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
 Text('E-1 해설 ${index+1} / ${questions.length}'), const SizedBox(height: 16), heading('정답의 이유를 확인하세요'),
 Text(q['prompt'] as String), const SizedBox(height: 20),
 panel('E-2 정답: ${q['answer']}', q['explanation'] as String), // P04 E-2
 panel('E-3 강의 근거', q['source'] as String, tinted: true), // P06 E-3 always visible, user decision 2026-10-29.
 FilledButton(onPressed: () => push(context, index+1 < questions.length ? QuizScreen(questions: questions, index: index+1, loader: loader) : ResultScreen(questions: questions, loader: loader)), child: Text(index+1 < questions.length ? 'E-4 다음 문제' : 'E-4 예시 결과 보기')), // P03 E-4
 ]));
 }
}
