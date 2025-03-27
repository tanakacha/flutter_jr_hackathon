import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2秒後に自動的に画面遷移
    Timer(const Duration(seconds: 2), () {
      context.go('/game');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム設定'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("ゲームへ"),
          onPressed: () {
            context.go('/game');
          },
        ),
      ),
    );
  }
}
