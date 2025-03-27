import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroController {
  double x = 0.0;  // ジャイロデータX
  double y = 0.0;  // ジャイロデータY
  double z = 0.0;  // ジャイロデータZ

  double targetX = 0.0;  // 的のX座標
  double targetY = 0.0;  // 的のY座標
  final Random random = Random();
  final double threshold = 0.1;  // 閾値

  void initGyro() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      // ジャイロデータを更新
      x = event.x;
      y = event.y;
      z = event.z;

      // 的の座標を更新
      targetX += y * 10;  // Y軸でX座標を更新
      targetY += x * 10;  // X軸でY座標を更新
      print('Gyro: x=$x, y=$y, z=$z');
    });
  }

  void generateNewTarget(BuildContext context) {
    // ランダムな位置に的を生成
    targetX = random.nextDouble() * MediaQuery.of(context).size.width;
    targetY = random.nextDouble() * MediaQuery.of(context).size.height;
    print('New Target: ($targetX, $targetY)');
  }

  void resetPosition() {
    // ジャイロと的をリセット
    x = 0.0;
    y = 0.0;
    z = 0.0;
    targetX = 0.0;
    targetY = 0.0;
  }
}
