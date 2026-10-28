// R-1 Text 예시 결과 P01; R-2 Container+Text 다시 볼 개념 P06; R-3 OutlinedButton 해설 다시 보기 P03; R-4 FilledButton 새 강의 입력 P03
import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets.dart';
import 'explanation.dart';
class ResultScreen extends StatelessWidget {
 const ResultScreen({super.key, required this.questions, required this.loader});
 final Rows questions; final Loader loader;
 @override Widget build(BuildContext context) => StudyPage(title: '예시 결과', child: LoadRows(resource: 'results', loader: loader, builder: (rows) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
 heading('R-1 복습을 이어 가세요'), Text(rows.first['label'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const Text('고정 예시입니다. 실제 선택을 채점한 결과가 아닙니다.'), const SizedBox(height: 24), // P01 R-1
 panel('R-2 다시 볼 개념', rows.first['review'] as String), // P06 R-2
 OutlinedButton(onPressed: () => push(context, ExplanationScreen(questions: questions, index: 0, loader: loader)), child: const Text('R-3 해설 다시 보기')), const SizedBox(height: 12), // P03 R-3
 FilledButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('R-4 새 강의 입력')), // P03 R-4
 // STATE: learning history / wrong-answer list -> future feature, not implemented.
 ])));
}
