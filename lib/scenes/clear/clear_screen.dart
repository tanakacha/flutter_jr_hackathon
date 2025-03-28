import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({super.key});

  @override
  State<ClearScreen> createState() => _ClearScreenState();
}

class _ClearScreenState extends State<ClearScreen> {
  @override
  void initState() {
    super.initState();
    stopAlarm();
  }

  Future<void> stopAlarm() async {
    await Alarm.stopAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('クリア！！'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('タイマー1: '),
            Text('タイマー2: '),
          ],
        ),
      ),
    );
  }
}
