import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/provider/wake_up_time_provider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckScreen extends ConsumerStatefulWidget {
  const CheckScreen({super.key});

  @override
  ConsumerState<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends ConsumerState<CheckScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(wakeUpTimeNotifierProvider.notifier).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final checkTime = ref.watch(wakeUpTimeNotifierProvider);
    final WakeUpMinutes =
        ref.watch(wakeUpTimeNotifierProvider.notifier).minutes;
    final WakeUpSeconds =
        ref.watch(wakeUpTimeNotifierProvider.notifier).seconds;

    return Scaffold(
      appBar: AppBar(
        title: Text('確認画面'),
      ),
      body: Column(
        children: [
          Gap(80),
          Text(
            '体を起こしましたか？',
            style: TextStyle(fontSize: 30),
          ),
          Gap(20),
          Text(
            '${WakeUpMinutes.toString().padLeft(2, '0')}:${WakeUpSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Gap(150),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                child: Text(
                  'はい',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  ref.read(wakeUpTimeNotifierProvider.notifier).stopTimer();

                  print('timer');

                  // context.go('/game');
                  context.go('/game', extra: {'checkTime': checkTime});
                  print('timer');
                  print(checkTime);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: Colors.blueAccent[100],
                ),
                child: Text(
                  'いいえ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
