import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared_ui/widgets/q_quiz_card.dart';
import '../../providers/home_providers.dart';
import '../../providers/quiz_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/category_filters.dart';

/// Home page displaying list of available quizzes with search and filters
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredQuizzesAsync = ref.watch(filteredQuizzesProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Image.asset(
              'assets/images/Qester_LOGO.png',
              height: 52,
              width: 52,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text('Start'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(quizzesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Header with greeting and search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const HomeHeader(),
              ),
            ),

            // Category filters
            const SliverToBoxAdapter(
              child: CategoryFilters(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            // Quiz list
            filteredQuizzesAsync.when(
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nie znaleziono quizów',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Spróbuj zmienić filtry lub wyszukiwanie',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final quiz = quizzes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: QQuizCard(
                            title: quiz.title,
                            subtitle: quiz.subtitle,
                            thumbnailUrl: quiz.thumbnailUrl,
                            questionCount: quiz.questionCount,
                            participantsCount: quiz.participantsCount,
                            difficulty: quiz.difficulty,
                            onTap: () {
                              // TODO: Navigate to quiz details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening ${quiz.title}...'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: quizzes.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Błąd ładowania quizów',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(quizzesProvider);
                        },
                        child: const Text('Spróbuj ponownie'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
