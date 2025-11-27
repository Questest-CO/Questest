import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'creator/presentation/pages/create_quiz_step1_page.dart';
import 'home/presentation/pages/home_page.dart';
import 'profile/presentation/pages/profile_page.dart';

/// Main screen with bottom navigation bar and FAB
/// Manages navigation between Start and Profile tabs
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Using IndexedStack to preserve state between tab switches
  final List<Widget> _pages = const [
    HomePage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openQuizCreator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateQuizStep1Page(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Floating Action Button for creating new quiz
      floatingActionButton: FloatingActionButton(
        onPressed: _openQuizCreator,
        backgroundColor: AppTheme.successColor,
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: 'Utwórz nowy quiz',
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          height: 70,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Start tab
              Expanded(
                child: InkWell(
                  onTap: () => _onTabTapped(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        size: 24,
                        color: _currentIndex == 0
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: _currentIndex == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: _currentIndex == 0
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer for FAB
              const SizedBox(width: 80),
              // Profile tab
              Expanded(
                child: InkWell(
                  onTap: () => _onTabTapped(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 24,
                        color: _currentIndex == 1
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: _currentIndex == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: _currentIndex == 1
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
