import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/main_screen.dart';

void main() {
  runApp(
    // ProviderScope is required for Riverpod
    const ProviderScope(
      child: QuestestApp(),
    ),
  );
}

/// Main application widget
class QuestestApp extends StatelessWidget {
  const QuestestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questest',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Home Screen
      home: const MainScreen(),
    );
  }
}
