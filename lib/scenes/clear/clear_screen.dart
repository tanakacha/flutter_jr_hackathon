import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({super.key});

  @override
  State<ClearScreen> createState() => _ClearScreenState();
}
class _ClearScreenState extends State<ClearScreen> {
  int checkTime = 0;
  int gameTime = 0;

  @override
  void initState() {
    super.initState();
    stopAlarm();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クリア！！'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('タイマー1: ${formatTime(checkTime)}',
                style: TextStyle(fontSize: 24)),
            Text('タイマー2: ${formatTime(gameTime)}',
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
    );
  }
}

// class _ClearScreenState extends State<ClearScreen> {
//   int checkTime = 0;
//   int gameTime = 0;

//   @override
//   void initState() {
//     super.initState();
//     stopAlarm();

//     // ルートから値を取得
//     final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
//     if (extra != null) {
//       setState(() {
//         checkTime = extra['checkTime'] ?? 0;
//         gameTime = extra['gameTime'] ?? 0;
//       });
//     }
//   }

//   Future<void> stopAlarm() async {
//     await Alarm.stopAll();
//   }

//   String formatTime(int totalSeconds) {
//     int minutes = totalSeconds ~/ 60;
//     int seconds = totalSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('クリア！！'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('タイマー1: ${formatTime(checkTime)}',
//                 style: TextStyle(fontSize: 24)),
//             Text('タイマー2: ${formatTime(gameTime)}',
//                 style: TextStyle(fontSize: 24)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 context.go('/');
//               },
//               child: const Text('アラームへ'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
