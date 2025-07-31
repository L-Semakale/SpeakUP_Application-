import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snap) {
        if (!snap.hasData) return const LoginScreen();

        final user = snap.data!;
        // If displayName is null we haven’t run profile setup yet
        if (user.displayName == null || user.displayName!.isEmpty) {
          // pushReplacementNamed avoids back-button confusion
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(context, '/setup'),
          );
          return const SizedBox.shrink();
        }

        return HomeScreen(userName: user.displayName!);
      },
    );
  }
}