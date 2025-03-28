import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/widget/game/fps_test.dart';
import 'package:flutter_jr_hackathon/utils/game/gyro/gyro_calc.dart';
import 'package:flutter_jr_hackathon/widget/target_widget.dart';
import 'package:flutter_jr_hackathon/widget/timer_widget.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GyroController gyroController = GyroController();
  final int targetCount = 5; // 当たり判定の許容範囲

  @override
  void initState() {
    super.initState();
    gyroController.initGyro();
    // gyroController.generateMultipleTargets(context, targetCount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gyroController.generateMultipleTargets(context, targetCount);
  }

  // void checkHit() {
  //   double centerX = MediaQuery.of(context).size.width / 2;
  //   double centerY = MediaQuery.of(context).size.height / 2;

  //   if ((gyroController.targetX - centerX).abs() < tolerance &&
  //       (gyroController.targetY - centerY).abs() < tolerance) {
  //     print('Hit! (${gyroController.targetX}, ${gyroController.targetY})');
  //     gyroController.generateNewTarget(context);
  //   } else {
  //     print('Miss! (${gyroController.targetX}, ${gyroController.targetY})');
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
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
            // ...gyroController.targets.map((target) => TargetWidget(
            //       x: target.dx,
            //       y: target.dy,
            //     )),
            // 的ウィジェット
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(Icons.adjust, size: 60, color: Colors.blue),
                  const SizedBox(height: 30),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        FPSGameTest(), // 3Dゲーム画面を内蔵
                        Center(
                          child: Icon(
                            Icons.adjust,
                            size: 60,
                            color: Colors.blue,
                          ), // アイコンを中央に配置
                        ),
                      ],
                    ),
                  ),

                  // Shootボタン
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      side: BorderSide(
                        color: Colors.grey,
                        width: 4,
                      ),
                      backgroundColor: const Color.fromARGB(177, 255, 0, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Shoot',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
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
                        '×score/10',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
