import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/widget/game/3dgame_widget.dart';
import 'package:flutter_jr_hackathon/scenes/timer/timer_screen.dart';
import 'package:flutter_jr_hackathon/scenes/widget/game/fps_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  // @override

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text('Gyroscope values:'),
            // Text('x: $x'),
            // Text('y: $y'),
            // Text('z: $z'),
            Expanded(
              flex: 3,
              child: FPSGameTest(), // 3Dゲーム画面を内蔵
            ),

            const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.grey[300],
            //         shape: const CircleBorder(),
            //         padding: const EdgeInsets.all(30),
            //       ),
            //       child: const Text(
            //         'RESET',
            //         style: TextStyle(fontSize: 16, color: Colors.black),
            //       ),
            //     ),
            //     const SizedBox(width: 30),
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.red[300],
            //         shape: const CircleBorder(),
            //         padding: const EdgeInsets.all(30),
            //       ),
            //       child: const Text(
            //         'TAP',
            //         style: TextStyle(fontSize: 16, color: Colors.white),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 40),
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
