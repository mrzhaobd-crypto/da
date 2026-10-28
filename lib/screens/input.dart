// I-1 TextField 강의 내용 P05; I-2 TextButton 예시 강의 P06; I-3 FilledButton 예시 요약 확인 P04
import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets.dart';
import 'summary.dart';
const sampleLecture = 'Flutter의 화면은 현재 상태를 바탕으로 그려집니다. 위젯은 부모의 제약 안에서 크기를 정합니다. 수평 프로토타입은 실제 저장이나 계산 없이 주요 화면 흐름을 보여 줍니다.';
class LectureInputScreen extends StatefulWidget {
 const LectureInputScreen({super.key, required this.loader}); final Loader loader;
 @override State<LectureInputScreen> createState() => _LectureInputScreenState();
}
class _LectureInputScreenState extends State<LectureInputScreen> {
 final controller = TextEditingController(); bool invalid = false;
 @override void dispose() { controller.dispose(); super.dispose(); }
 // STATE: lecture text -> I-1; transient view only, not transmitted.
 @override Widget build(BuildContext context) => StudyPage(title: '강의 입력', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
   heading('강의 노트를\n복습의 시작으로'),
   const Text('강의 노트나 PDF에서 복사한 텍스트를 붙여넣으세요. 이번 시연은 입력과 관계없이 준비된 Flutter 강의 예시를 보여 줍니다.'), const SizedBox(height: 24),
   TextField(controller: controller, minLines: 6, maxLines: 10, decoration: InputDecoration(labelText: 'I-1 강의 내용', hintText: '여기에 강의 텍스트를 붙여넣으세요', border: const OutlineInputBorder(), errorText: invalid ? '강의 내용을 입력하거나 예시를 불러오세요.' : null)), // P05 I-1
   Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => setState(() { controller.text = sampleLecture; invalid = false; }), child: const Text('I-2 예시 강의 불러오기'))), // P06 I-2
   FilledButton(onPressed: () { if(controller.text.trim().isEmpty) { setState(() => invalid = true); return; } push(context, SummaryScreen(loader: widget.loader)); }, child: const Text('I-3 예시 요약 확인')), // P04 I-3
 ]));
}
