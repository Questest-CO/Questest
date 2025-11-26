import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
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
      ],
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
