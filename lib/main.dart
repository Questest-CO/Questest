import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const QesterApp());
}

class QesterApp extends StatefulWidget {
  const QesterApp({super.key});

  @override
  State<QesterApp> createState() => _QesterAppState();
}

class _QesterAppState extends State<QesterApp> {
  int _currentIndex = 0;

  static const Color _primary = Color(0xFF3A5B9A);
  static const Color _secondary = Color(0xFF4DCC8F);
  static const Color _tertiary = Color(0xFFDDEEFF);
  static const Color _surface = Color(0xFFF8F9FF);
  static const Color _onSurface = Color(0xFF1C1C1E);
  static const Color _onPrimary = Color(0xFFFFFFFF);

  late final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _primary,
      onPrimary: _onPrimary,
      secondary: _secondary,
      onSecondary: _onPrimary,
      tertiary: _tertiary,
      onTertiary: _onSurface,
      error: Colors.red,
      onError: _onPrimary,
      background: _surface,
      onBackground: _onSurface,
      surface: _surface,
      onSurface: _onSurface,
    ),
    scaffoldBackgroundColor: _surface,
    textTheme: Typography.englishLike2021.apply(
      bodyColor: _onSurface,
      displayColor: _onSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _onSurface,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _primary,
      unselectedItemColor: Color(0xFF757575),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: _surface,
    ),
  );

  final List<Widget> _pages = const [
    HomeScreen(),
    ResultsScreen(),
    StatsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qester',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: Scaffold(
        body: _pages[_currentIndex],
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: _secondary,
                foregroundColor: _onPrimary,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Start',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Rankingi',
            ),
          ],
        ),
      ),
    );
  }
}

