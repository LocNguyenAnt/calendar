import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/theme.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: appBar ??
          AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeNotifier.toggleTheme();
                },
              ),
            ],
          ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
