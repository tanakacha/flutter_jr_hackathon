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
  final themaColor = Colors.red;
  List<AlarmSettings> alarms = [];
  Notifications? notifications;

  static StreamSubscription<AlarmSet>? ringSubscription;
  static StreamSubscription<AlarmSet>? updateSubscription;
  bool hasNavigatedToCheck = false;

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

    // アラームが鳴っている間、画面遷移を繰り返す
    while (alarms.alarms.isNotEmpty) {
      if (!mounted) break; // ウィジェットが破棄されている場合はループを終了

      // 遷移済みでない場合のみ遷移
      if (!hasNavigatedToCheck) {
        print('Navigating to /check because alarm is ringing');
        context.go('/check'); // 確認画面に遷移
        hasNavigatedToCheck = true; // 遷移済みフラグを設定
      }

      // 一定時間待機してから再度遷移
      await Future.delayed(Duration(seconds: 5));
    }
    // アラームリストを更新
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
    ringSubscription = null;
    updateSubscription?.cancel();
    updateSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'アラーム設定',
          style: TextStyle(color: Colors.red), // テキストの色を赤に設定
        ),
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
                            Icon(
                              Icons.alarm_add_rounded,
                              size: 33,
                              color: themaColor,
                            ),
                            Text(
                              '新規めざまし作成',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            Gap(10),
                          ],
                        ),
                      ),
              ),

              Gap(0),
            ],
          ),
        ),
      ),
    );
  }
}
