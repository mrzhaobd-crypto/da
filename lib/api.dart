// Template adaptation: local json-server GET only.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

typedef Rows = List<Map<String, dynamic>>;
typedef Loader = Future<Rows> Function(String resource);
const demoState = String.fromEnvironment('DEMO_STATE');
String get apiBase {
  const override = String.fromEnvironment('API_BASE');
  if (override.isNotEmpty) return override;
  return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
}

Future<Rows> getRows(String resource) async {
  if (demoState == 'loading') {
    await Future<void>.delayed(const Duration(seconds: 3));
  }
  if (demoState == 'empty') return [];
  if (demoState == 'error') throw Exception('시연용 연결 오류');
  final response = await http
      .get(Uri.parse('$apiBase/$resource'))
      .timeout(const Duration(seconds: 5));
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  if (data is! List) throw const FormatException('목록 형식이 아닙니다');
  return data.map((row) => Map<String, dynamic>.from(row as Map)).toList();
}
