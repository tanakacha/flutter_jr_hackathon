import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム設定'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("ゲームへ"),
          onPressed: () {
            context.go('/game');
          },
        ),
      ),
    );
  }
}
