import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/discovery_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C-Drama Lore Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DiscoveryScreen(),
    );
  }
}