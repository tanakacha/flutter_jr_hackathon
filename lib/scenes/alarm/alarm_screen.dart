import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/alarm/components/alarm_tile.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:flutter_jr_hackathon/model/alarm_settings.dart';
import 'package:flutter_jr_hackathon/scenes/alarm/components/edit_alarm_screen.dart';
import 'package:flutter_jr_hackathon/scenes/alarm/components/ring_screen.dart';
import 'package:flutter_jr_hackathon/services/notification.dart';
import 'package:flutter_jr_hackathon/services/permission.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<AlarmSettings> alarms = [];
  Notifications? notifications;

  static StreamSubscription<AlarmSet>? ringSubscription;
  static StreamSubscription<AlarmSet>? updateSubscription;

  // 途中
  @override
  void initState() {
    super.initState();
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );
    unawaited(loadAlarms());
    ringSubscription ??= Alarm.ringing.listen(ringingAlarmsChanged);
    updateSubscription ??= Alarm.scheduled.listen((_) {
      unawaited(loadAlarms());
    });
    notifications = Notifications();
  }

  // フル
  // アラームは基本１つしか用意しないからAlarm.getAlarm()でも問題ないけど、exAppに合わせる
  Future<void> loadAlarms() async {
    final updateAlarms = await Alarm.getAlarms();
    updateAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    if (!mounted) return;
    setState(() {
      alarms = updateAlarms;
    });
  }

  // フル
  Future<void> ringingAlarmsChanged(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    // 仮の確認画面用
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) {
    //     return RingScreen(alarmSettings: alarms.alarms.first);
    //   }),
    // );
    context.go('/check'); // 確認画面に遷移する
    if (mounted) {
      unawaited(loadAlarms());
    }
  }

  // フル
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: EditAlarmScreen(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) unawaited(loadAlarms());
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム設定'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Gap(0),
              SizedBox(
                height: 80, // AlarmTile の高さに合わせる
                child: alarms.isNotEmpty
                    ? ListView(
                        physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
                        children: [
                          AlarmTile(
                            key: Key(alarms[0].id.toString()),
                            title: TimeOfDay(
                                    hour: alarms[0].dateTime.hour,
                                    minute: alarms[0].dateTime.minute)
                                .format(context),
                            onPressed: () {
                              navigateToAlarmScreen(alarms[0]);
                            },
                            onDismissed: () {
                              Alarm.stop(alarms[0].id)
                                  .then((_) => loadAlarms());
                            },
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          navigateToAlarmScreen(null);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.alarm_add_rounded, size: 33),
                            Text('新規めざまし作成'),
                            Gap(10),
                          ],
                        ),
                      ),
                // Center(
                //     child: Text(
                //       'アラームなし',
                //       style: Theme.of(context).textTheme.titleMedium,
                //     ),
                //   ),
              ),
              // FloatingActionButton(
              //   onPressed: () {
              //     navigateToAlarmScreen(null);
              //   },
              //   child: Icon(Icons.alarm_add_rounded, size: 33),
              // ),
              // ElevatedButton(
              //   child: Text("確認画面へ"),
              //   onPressed: () {
              //     context.go('/check');
              //   },
              // ),
              // ゲームへというボタンをコメントアウトするとUIが崩れるのでその時は代わりに"Gap(0),"を書いてください、"Row(),"とかでも構いません
              ElevatedButton(
                child: Text("ゲームへ"),
                onPressed: () {
                  context.go('/game');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
