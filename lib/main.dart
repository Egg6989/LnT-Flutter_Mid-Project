import 'package:flutter/material.dart';
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
      home: Scaffold(
        appBar: AppBar(title: const Text('MyFit'),),
        body: Center(
          child: Text('Hello there!',),
        ),
      ),
    );
  }
}
