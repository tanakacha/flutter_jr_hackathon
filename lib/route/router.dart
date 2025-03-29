import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/check/check_screen.dart';
import 'package:flutter_jr_hackathon/scenes/clear/clear_screen.dart';
import 'package:flutter_jr_hackathon/scenes/game/game_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_jr_hackathon/scenes/alarm/alarm_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => AlarmScreen(),
      ),
      GoRoute(
        path: '/check',
        builder: (context, state) => CheckScreen(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?; // `extra` を取得
          final checkTime = extra?['checkTime'] ?? 0; // デフォルト値を設定
          return GameScreen();
        },
      ),
      GoRoute(
        path: '/clear',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?; // `extra` を取得
          final checkTime = extra?['checkTime'] ?? 0;
          final gameTime = extra?['gameTime'] ?? 0;
          return ClearScreen(); // `ClearScreen` に値を渡す
        },
      ),
    ],
  );
}
