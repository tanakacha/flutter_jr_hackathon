import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/alarm/alarm_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlarmScreen(),
    );
  }
}
