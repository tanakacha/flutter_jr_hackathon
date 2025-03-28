import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroController {
  List<Offset> targets = [];    // 複数の的の座標を格納
  final Random random = Random();

  double x = 0.0, y = 0.0, z = 0.0;  // ジャイロセンサーの値

  /// ジャイロセンサー初期化
  void initGyro() {
    gyroscopeEvents.listen((event) {
      x = event.x;
      y = event.y;
      z = event.z;
    });
  }

  /// ランダムな座標を生成
  Offset generateRandomTarget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double targetX = random.nextDouble() * (width - 100) + 50;  // 50pxのマージン
    double targetY = random.nextDouble() * (height - 200) + 100;

    return Offset(targetX, targetY);
  }

  /// 複数の的をランダムに配置
  void generateMultipleTargets(BuildContext context, int count) {
    targets = List.generate(count, (_) => generateRandomTarget(context));
  }
}
