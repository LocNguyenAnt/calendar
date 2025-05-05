// lib/router.dart
import 'package:flutter_calendar_project/main.dart';
import 'package:flutter_calendar_project/screens/calendar_screen.dart';
import 'package:flutter_calendar_project/screens/favourite_screen.dart';
import 'package:flutter_calendar_project/screens/generator_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const GeneratorScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
      ],
    ),
  ],
);
