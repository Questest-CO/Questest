import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
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
      home: const AuthGate(),
    );
  }
}
