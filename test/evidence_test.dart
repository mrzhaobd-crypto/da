import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notequiz/widgets.dart';
void main() {
 testWidgets('capture common states from real widgets', (t) async {
  await t.runAsync(() async {
    final bytes=await File(Platform.environment['EVIDENCE_FONT']!).readAsBytes();
    await (FontLoader('EvidenceFont')..addFont(Future.value(ByteData.sublistView(bytes)))).load();
    if(Platform.environment['EVIDENCE_ICONS'] != null) {
      final icons=await File(Platform.environment['EVIDENCE_ICONS']!).readAsBytes();
      await (FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(icons)))).load();
    }
  });
  await t.binding.setSurfaceSize(const Size(390,844));
  for (final name in ['loading','error','empty']) {
   final key=GlobalKey();
   final Widget state = switch(name) {'loading'=>const LoadingView(), 'error'=>ErrorView(onRetry:(){}), _=>const EmptyView()};
   await t.pumpWidget(RepaintBoundary(key:key,child:MaterialApp(debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,fontFamily:'EvidenceFont'),home:StudyPage(title:'핵심 요약',child:state))));
   await t.pump(const Duration(milliseconds:100));
   final boundary=key.currentContext!.findRenderObject() as RenderRepaintBoundary;
   await t.runAsync(() async {
   final image=await boundary.toImage(pixelRatio:2);
   final bytes=await image.toByteData(format:ui.ImageByteFormat.png);
   await File('docs/screenshots/$name-test.png').writeAsBytes(bytes!.buffer.asUint8List());});
  }
  await t.binding.setSurfaceSize(null);
 }, skip: Platform.environment['EVIDENCE_FONT'] == null);
}
