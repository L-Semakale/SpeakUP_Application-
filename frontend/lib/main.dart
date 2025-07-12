import 'package:flutter/material.dart';
import 'create_post_page.dart'; // <-- Import the file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Post App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreatePostPage(), // <-- Set it as the home screen
      debugShowCheckedModeBanner: false,
    );
  }
}
