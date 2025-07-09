import 'package:flutter/material.dart';
import '/screens/landing_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const SpeakUpApp());
}

class SpeakUpApp extends StatelessWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakUp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        // Add more routes here as needed
      },
    );
  }
}
