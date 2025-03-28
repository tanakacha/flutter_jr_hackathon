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
  double targetX = 0.0, targetY = 0.0;
  final Random random = Random();
  final double threshold = 0.1; // 閾値を設定

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        if (event.x.abs() > threshold || event.y.abs() > threshold) {
          // 閾値を超えた場合にのみ更新
          targetX += event.y * 10; // Y軸のデータを使用してX軸の値を更新
          targetY += event.x * 10; // X軸のデータを使用してY軸の値を更新
          print(
              'Gyroscope X: ${event.x}, Y: ${event.y}, Updated Target: ($targetX, $targetY)');
        }
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
      targetY = random.nextDouble() * MediaQuery.of(context).size.height;
      print('New Target: ($targetX, $targetY)');
    });
  }

  void checkHit() {
    double tolerance = 50.0; // 当たり判定の許容範囲
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height / 2;
    if ((targetX - centerX).abs() < tolerance &&
        (targetY - centerY).abs() < tolerance) {
      print('Hit! ($targetX, $targetY)');
      generateNewTarget();
    } else {
      print('Miss! ($targetX, $targetY)');
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
          Center(
            child:
                Icon(Icons.adjust, size: 50, color: Colors.blue), // 標準を画面の中央に固定
          ),
        ],
      ),
    );
  }
}
