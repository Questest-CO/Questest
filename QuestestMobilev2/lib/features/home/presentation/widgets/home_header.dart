import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../quiz/presentation/pages/quiz_solving_page.dart';
import '../../providers/home_providers.dart';

/// Header widget for home page with greeting and search field
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateChangesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        authState.when(
          data: (user) {
            final displayName = _resolveDisplayName(user);
            return Text(
              'Cześć, $displayName!',
              style: theme.textTheme.displaySmall,
            );
          },
          loading: () => Text(
            'Cześć, Użytkowniku!',
            style: theme.textTheme.displaySmall,
          ),
          error: (_, __) => Text(
            'Cześć, Użytkowniku!',
            style: theme.textTheme.displaySmall,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Znajdź quiz dla siebie',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),
        
        // Search Field
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Szukaj quizu...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),

        // TEST GAMEPLAY Button (temporary for development)
        const SizedBox(height: 16),
        _TestGameplayButton(),
      ],
    );
  }
}

/// Temporary button to test the quiz gameplay screen
/// TODO: Remove this when quiz list navigation is implemented
class _TestGameplayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withValues(alpha: 0.15),
            AppTheme.primaryColor.withValues(alpha: 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.science_outlined,
              color: AppTheme.accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tryb testowy',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Przetestuj ekran rozwiązywania quizu',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QuizSolvingPage(
                    quizId: '0',
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow, size: 18),
                SizedBox(width: 4),
                Text('TEST'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _resolveDisplayName(User? user) {
  final displayName = user?.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return _capitalize(displayName);
  }

  final email = user?.email?.trim();
  if (email == null || email.isEmpty) {
    return 'Użytkowniku';
  }

  final localPart = email.split('@').first.trim();
  if (localPart.isEmpty) {
    return 'Użytkowniku';
  }

  return _capitalize(localPart);
}

String _capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  if (value.length == 1) {
    return value.toUpperCase();
  }
  return value[0].toUpperCase() + value.substring(1);
}
