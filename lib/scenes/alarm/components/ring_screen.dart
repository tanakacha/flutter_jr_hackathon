import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RingScreen extends StatefulWidget {
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  // ログ不要
  // static final _log = Logger('ExampleAlarmRingScreenState');

  // 仮画面・不要
  // @override
  // void initState()
  // @override
  // void dispose()

  // 仮の画面
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(onPressed: () {}),
                RawMaterialButton(
                  onPressed: () async {
                    Alarm.stop(widget.alarmSettings.id);
                    context.go('/');
                  },
                  child: Text('停止'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
