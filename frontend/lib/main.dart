import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// import 'profile_screen.dart';
// import 'settings_screen.dart';
// import 'create_post_screen.dart';
// etc.

void main() {
  runApp(const SpeakUpApp());
}

class SpeakUpApp extends StatelessWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpeakUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),

        // Add other team screens here:
        // '/profile': (context) => const ProfileScreen(),
        // '/settings': (context) => const SettingsScreen(),
        // '/create_post': (context) => const CreatePostScreen(),
      },
    );
  }
}
