import 'package:flutter/material.dart';
import 'create_post_page.dart';
import 'resources_page.dart'; // <-- Add this line

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CreatePostPage(), // default home
        '/resources': (context) => const ResourcesPage(),
      },
    );
  }
}
