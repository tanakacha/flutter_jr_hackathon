import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class RingScreen extends StatefulWidget {
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;


  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  // まだ使ってない
  // static final _log = Logger('ExampleAlarmRingScreenState');

  // 途中
  // @override
  // void initState()

  // 途中
  // @override
  // void dispose()

  // 途中
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${widget.alarmSettings.id}) is ringing...',
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),

          ],
        ),
      ),
    );
  }
}
