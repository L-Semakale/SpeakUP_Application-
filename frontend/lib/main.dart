import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const SpeakUpApp());
}
class SpeakUpApp extends StatelessWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakUp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
