import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/provider/difficulty_provider.dart';
import 'package:flutter_jr_hackathon/scenes/widget/game/fps_game.dart';
import 'package:flutter_jr_hackathon/utils/game/gyro/gyro_calc.dart';
import 'package:flutter_jr_hackathon/scenes/widget/timer/timer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  // final GyroController gyroController = GyroController();
  int targetCount = 0;
  int targetCountMax = 10; // 最大ターゲット数
  int gameScreenTime = 0; // ゲーム経過時間
  Timer? _timer;
  int targetGoal = 10; // 目標スコア

  @override
  void initState() {
    super.initState();
    // gyroController.initGyro();
    startGameTimer(); // ゲームタイマーを開始
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // gyroController.generateMultipleTargets(context, targetCount);
  }

  void startGameTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        gameScreenTime++; // 1秒ごとにゲーム時間を増加
      });
    });
  }

  void stopGameTimer() {
    _timer?.cancel();
  }

  void handleTargetCountChanged(int newCount) {
    setState(() {
      targetCount = newCount;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // メモリリークを防ぐためにタイマーをキャンセル
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        GoRouterState.of(context).extra as Map<String, dynamic>?; // データを取得
    final checkTime = args?['checkTime'] ?? 0; // デフォルト0

    final difficulty = ref.watch(difficultyNotifierProvider);
    print('Difficulty: $difficulty');
    if (difficulty == 'Easy') {
      print('EasyTarget');
      targetGoal = 10;
    } else if (difficulty == 'Normal') {
      print('NormalTarget');
      targetGoal = 20;
    } else if (difficulty == 'Hard') {
      print('HardTarget');
      targetGoal = 30;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const TimerScene(),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, size: 32),
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        FPSGameTest(
                          onTargetCountChanged: handleTargetCountChanged,
                          checkTime: checkTime,
                          gameScreenTime: gameScreenTime,
                          targetGoal: targetGoal,
                        ),
                        Center(
                          child: Icon(
                            Icons.adjust,
                            size: 60,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.adjust,
                        size: 32,
                        color: Colors.amber,
                      ),
                      Text(
                        '×score ${targetCount}/$targetGoal',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      stopGameTimer(); // ゲーム終了時にタイマー停止
                      context.go('/clear', extra: {
                        'checkTime': checkTime,
                        'gameTime': gameScreenTime
                      });
                    },
                    child: Text('クリア画面へ'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
