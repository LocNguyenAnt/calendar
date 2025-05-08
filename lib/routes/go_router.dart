// lib/router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar_project/main.dart';
import 'package:flutter_calendar_project/screens/calendar_screen.dart';
import 'package:flutter_calendar_project/screens/favourite_screen.dart';
import 'package:flutter_calendar_project/screens/generator_screen.dart';
import 'package:flutter_calendar_project/screens/login_screen.dart';
import 'package:flutter_calendar_project/screens/register_screen.dart';
import 'package:flutter_calendar_project/widgets/go_router_refresh_stream.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn =
        state.fullPath == '/login' || state.fullPath == '/register';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/';

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const GeneratorScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
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
