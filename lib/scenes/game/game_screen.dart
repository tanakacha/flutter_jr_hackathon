import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ゲーム'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("設定へ"),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
    );
  }
}
