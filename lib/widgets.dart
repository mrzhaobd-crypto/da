import 'package:flutter/material.dart';
import 'api.dart';
const ink = Color(0xFF18243B);
const blue = Color(0xFF4F609B);
class StudyPage extends StatelessWidget {
  const StudyPage({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('NoteQuiz · $title')),
    body: SafeArea(child: LayoutBuilder(builder: (context, c) => Row(children: [
      if (c.maxWidth >= 840) const SizedBox(width: 230, child: Padding(padding: EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.auto_stories_outlined, size: 42, color: blue), SizedBox(height: 24),
        Text('핵심을 읽고\n이유를 확인하세요', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        SizedBox(height: 24), Text('강의 입력\n\n핵심 요약\n\n복습 퀴즈\n\n정답과 해설\n\n예시 결과'),
      ]))),
      Expanded(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1050), child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [child, const SizedBox(height: 30), const Text('수업용 UI 프로토타입 · 입력과 선택은 저장되지 않습니다', style: TextStyle(fontSize: 12, color: Colors.blueGrey))]))))),
    ]))),
  );
}
Widget heading(String text) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(text, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w700, color: ink)));
Widget panel(String label, String text, {bool tinted = false}) => Container(
  margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(color: tinted ? const Color(0xFFE9EEFC) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDDE2EC))),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: blue, fontWeight: FontWeight.w700)), const SizedBox(height: 12), Text(text, style: const TextStyle(fontSize: 18, height: 1.55))]),
);
class LoadingView extends StatelessWidget {
 const LoadingView({super.key});
 @override Widget build(BuildContext context) => const Padding(padding: EdgeInsets.all(40), child: Column(children: [CircularProgressIndicator(), SizedBox(height: 20), Text('학습 자료를 불러오는 중…')])); // P01 C-1
}
class ErrorView extends StatelessWidget {
 const ErrorView({super.key, required this.onRetry});
 final VoidCallback onRetry;
 @override Widget build(BuildContext context) => Column(children: [const Icon(Icons.wifi_off, size: 48), const SizedBox(height: 16), heading('자료를 불러오지 못했어요'), const Text('연결을 확인한 뒤 다시 시도해 주세요. 입력 화면으로 돌아갈 수도 있습니다.'), const SizedBox(height: 20), FilledButton(onPressed: onRetry, child: const Text('다시 시도')), TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('강의 입력으로'))]); // P09 C-2
}
class EmptyView extends StatelessWidget {
 const EmptyView({super.key});
 @override Widget build(BuildContext context) => Column(children: [const Icon(Icons.inbox_outlined, size: 48), const SizedBox(height: 16), heading('표시할 학습 자료가 없어요'), const Text('예시 자료가 비어 있습니다. 강의 입력으로 돌아가 주세요.'), TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('강의 입력으로'))]); // P01 C-3
}
class LoadRows extends StatefulWidget {
 const LoadRows({super.key, required this.resource, required this.loader, required this.builder});
 final String resource; final Loader loader; final Widget Function(Rows) builder;
 @override State<LoadRows> createState() => _LoadRowsState();
}
class _LoadRowsState extends State<LoadRows> {
 late Future<Rows> future;
 @override void initState() { super.initState(); future = widget.loader(widget.resource); }
 // STATE: GET request status -> common loading/error/empty; no shared state package.
 @override Widget build(BuildContext context) => FutureBuilder<Rows>(future: future, builder: (context, s) {
   if (s.connectionState != ConnectionState.done) return const LoadingView();
   if (s.hasError) return ErrorView(onRetry: () => setState(() { future = widget.loader(widget.resource); }));
   if (s.data == null || s.data!.isEmpty) return const EmptyView();
   return widget.builder(s.data!);
 });
}
void push(BuildContext context, Widget screen) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
