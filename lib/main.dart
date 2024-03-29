import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey:
              "AIzaSyAzaoSTEdlNubxgJEPcnVZbKlPlf9nVD3E", // these lines are what connect it to my firebase account
          appId: "1:998860827066:web:64b8fe8db8f93acecf9583",
          messagingSenderId: "998860827066",
          projectId: "resilience-finance"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      home: LoginScreen(),
    );
  }
}
