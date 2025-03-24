import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double x = 0.0, y = 0.0, z = 0.0;
  double targetX = 0.0, targetY = 0.0;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        x += event.y * 3; // X軸のみを更新
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    generateNewTarget(); // 初期ターゲットを生成
  }

  void generateNewTarget() {
    setState(() {
      targetX = random.nextDouble() * MediaQuery.of(context).size.width;
      targetY = MediaQuery.of(context).size.height / 2; // Y座標を画面の中央に固定
    });
  }

  void checkHit() {
    double tolerance = 50.0; // 当たり判定の許容範囲
    if ((x - targetX).abs() < tolerance) {
      print('$x, $targetX, $x - $targetX');
      print('Hit!');
      generateNewTarget();
    } else {
      print('$x, $targetX, $x - $targetX');
      print('Miss!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('シューティングゲーム'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: targetX,
            top: targetY,
            child: Icon(Icons.adjust, size: 50, color: Colors.red),
          ),
          Center(
            child: ElevatedButton(
              onPressed: checkHit,
              child: Text('Shoot'),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 + x * 10, // X軸のみを動かす
            top: MediaQuery.of(context).size.height / 2,
            child: Icon(Icons.adjust, size: 50, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
