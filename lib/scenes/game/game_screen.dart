import 'package:flutter/material.dart';
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
  final double tolerance = 50.0; // 当たり判定の許容範囲

  @override
  void initState() {
    super.initState();
    gyroController.initGyro();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gyroController.generateNewTarget(context);
  }

  void checkHit() {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height / 2;

    if ((gyroController.targetX - centerX).abs() < tolerance &&
        (gyroController.targetY - centerY).abs() < tolerance) {
      print('Hit! (${gyroController.targetX}, ${gyroController.targetY})');
      gyroController.generateNewTarget(context);
    } else {
      print('Miss! (${gyroController.targetX}, ${gyroController.targetY})');
    }
    setState(() {});
  }

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
          ],
        ),
        body: Stack(
          children: [
            // 的ウィジェット
            TargetWidget(
              x: gyroController.targetX,
              y: gyroController.targetY,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text('Gyroscope values:'),
                  // Text('x: ${gyroController.x.toStringAsFixed(2)}'),
                  // Text('y: ${gyroController.y.toStringAsFixed(2)}'),
                  // Text('z: ${gyroController.z.toStringAsFixed(2)}'),
                  const Icon(Icons.adjust, size: 60, color: Colors.blue),
                  const SizedBox(height: 30),

                  // Shootボタン
                  ElevatedButton(
                    onPressed: checkHit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Shoot',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Resetボタン
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 設定画面へボタン
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      '設定画面へ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
