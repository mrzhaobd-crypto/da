import 'package:flutter/material.dart';

import 'api.dart';
import 'widgets.dart';
import 'screens/input.dart';

void main() => runApp(const NoteQuizApp());

class NoteQuizApp extends StatelessWidget {
  const NoteQuizApp({super.key, this.loader = getRows});

  final Loader loader;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NoteQuiz',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      scaffoldBackgroundColor: const Color(0xFFF5F7FC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F7FC),
        foregroundColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(0, 52)),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, height: 1.5),
      ),
    ),
    home: LectureInputScreen(loader: loader),
  );
}
