import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double x = 0.0, y = 0.0, z = 0.0;
  int timerValue = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });

    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // タイマーをスタート
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timerValue++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '00:00:${timerValue.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 32),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gyroscope values:'),
            Text('x: $x'),
            Text('y: $y'),
            Text('z: $z'),
            ElevatedButton(
              child: const Text("設定画面へ"),
              onPressed: () {
                context.go('/');
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(30),
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(30),
                  ),
                  child: const Text(
                    'TAP',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
    );
  }
}
