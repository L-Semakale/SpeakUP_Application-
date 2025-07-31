import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Firebase init error: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firestore Test')),
        body: FirestoreTest(),
      ),
    );
  }
}

class FirestoreTest extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _testConnection() async {
    try {
      await _firestore.collection('test').doc('test').set({'test': 'value'});
      print('Write successful');
    } catch (e) {
      print('Firestore error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _testConnection,
            child: Text('Test Firestore Connection'),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('test').doc('test').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (!snapshot.hasData) return Text('Loading...');
              return Text('Data: ${snapshot.data!.data()}');
            },
          ),
        ],
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('Initialization Error: $error'))),
    );
  }
}
