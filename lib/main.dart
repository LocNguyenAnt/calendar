import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/firebase_options.dart';
import 'package:flutter_calendar_project/layouts/layout.dart';
import 'package:flutter_calendar_project/routes/go_router.dart';
import 'package:flutter_calendar_project/services/app_state.dart';
import 'package:flutter_calendar_project/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppState()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp.router(
      title: 'Calendar',
      theme: themeNotifier.currentTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static const tabs = ['/', '/favorites', '/calendar'];

  int _locationToTabIndex(String location) {
    final index = tabs.indexOf(location);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).fullPath ?? '';

    final int currentIndex = _locationToTabIndex(location);

    return AppScaffold(
      body: child,
      bottomNavigationBar: _hideBottomNavBar(context)
          ? null
          : NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                context.go(tabs[index]);
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.favorite), label: 'Favorites'),
                NavigationDestination(
                    icon: Icon(Icons.calendar_today), label: 'Calendar'),
              ],
            ),
    );
  }
}

bool _hideBottomNavBar(BuildContext context) {
  final location = GoRouterState.of(context).fullPath;
  return location == '/login' || location == '/register';
}
