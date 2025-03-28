import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class RingScreen extends StatefulWidget {
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  // ログ不要
  static final _log = Logger('ExampleAlarmRingScreenState');

  StreamSubscription<AlarmSet>? _ringingSubscription;

  // 仮画面・不要
  @override
  void initState() {
    super.initState();
    _ringingSubscription = Alarm.ringing.listen((alarms) {
      if (alarms.containsId(widget.alarmSettings.id)) return;
      _log.info('Alarm ${widget.alarmSettings.id} stopped ringing.');
      _ringingSubscription?.cancel();
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

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
