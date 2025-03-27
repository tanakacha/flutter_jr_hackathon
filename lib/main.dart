import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jr_hackathon/route/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面を縦向きに固定する
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 確認ログ
  // setupLogging(showDebugLogs: true);

  await Alarm.init();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
    );
  }
}
