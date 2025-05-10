import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({super.key});

  @override
  State<ClearScreen> createState() => _ClearScreenState();
}

class _ClearScreenState extends State<ClearScreen> {
  int checkTime = 0;
  int gameTime = 0;
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 10)); //

  @override
  void initState() {
    super.initState();
    stopAlarm();
    _confettiController.play(); // 紙吹雪を開始
  }

  @override
  void dispose() {
    _confettiController.dispose(); // 紙吹雪のコントローラーを破棄
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ルートから値を取得
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null) {
      setState(() {
        checkTime = extra['checkTime'] ?? 0;
        gameTime = extra['gameTime'] ?? 0;
      });
    }
  }

  Future<void> stopAlarm() async {
    await Alarm.stopAll();
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getRank(int checkTime, int gameTime) {
    if (checkTime <= 5 && gameTime <= 30) {
      return 'S';
    } else if (checkTime <= 10 && gameTime <= 60) {
      return 'A';
    } else if (checkTime <= 20 && gameTime <= 90) {
      return 'B';
    } else if (checkTime <= 30 && gameTime <= 120) {
      return 'C';
    } else {
      return 'D';
    }
  } // ランクを決定する関数

  @override
  Widget build(BuildContext context) {
    final String rank = getRank(checkTime, gameTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('クリア！！'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ランク表示
                Text(
                  "ランク", // ランクの文字
                  style: TextStyle(
                    fontSize: 40, // 大きなフォントサイズ
                    fontWeight: FontWeight.bold, // 太字
                  ),
                ),
                Text(
                  rank, // ランクを表示
                  style: TextStyle(
                    fontSize: 80, // 大きなフォントサイズ
                    fontWeight: FontWeight.bold, // 太字
                    color: Color(0xFFFFD700), // ランクの色
                  ),
                ),
                const SizedBox(height: 20), // ランクとタイムの間にスペースを追加
                Text('起床時間: ${formatTime(checkTime)}',
                    style: TextStyle(fontSize: 24)),
                Text('撃破時間:${formatTime(gameTime)}',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('アラームへ'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter, // 紙吹雪の位置を調整
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // 紙吹雪の方向
              shouldLoop: true, // 紙吹雪をループさせない
              numberOfParticles: 30,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow
              ], // 紙吹雪の色
            ),
          ),
        ],
      ),
    );
  }
}
