import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jr_hackathon/route/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面を縦向きに固定する
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 確認ログ
  // setupLogging(showDebugLogs: true);

  await Alarm.init();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'CustomFont', // アプリ全体にカスタムフォントを適用
      ),
      routerConfig: AppRouter.router,
    );
  }
}
