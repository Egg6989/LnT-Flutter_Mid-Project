import 'package:flutter/material.dart';
import 'screens.dart';
import 'models.dart';
// Flutter Mid-Project: Fitness Tracker

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFit - Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(
          numSteps: const [],
          water: const [],
      ),
    );
  }
}
