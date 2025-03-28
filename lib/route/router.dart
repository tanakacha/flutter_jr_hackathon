import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/check/check_screen.dart';
import 'package:flutter_jr_hackathon/scenes/game/game_screen.dart';
import 'package:go_router/go_router.dart';
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
        builder: (context, state) => GameScreen(),
      ),
    ],
  );
}
