import 'dart:math';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../shared_ui/widgets/q_primary_button.dart';
import '../../../ranking/presentation/pages/ranking_page.dart';
import '../../providers/quiz_result_provider.dart';
import '../../providers/quiz_controller.dart';

/// "Twój wynik" screen with donut chart and dynamic messages.
class QuizResultPage extends ConsumerStatefulWidget {
  const QuizResultPage({
    super.key,
    required this.quizId,
    required this.quizTitle,
    required this.scorePercent,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  /// Quiz ID (needed to save the result)
  final int quizId;

  /// Quiz title (for sharing)
  final String quizTitle;

  /// Score in percentage (0-100)
  final double scorePercent;

  /// Number of correct answers
  final int correctAnswers;

  /// Total number of questions
  final int totalQuestions;

  @override
  ConsumerState<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends ConsumerState<QuizResultPage> {
  
  // ============ BUTTON HANDLERS ============
  
  /// "Spróbuj ponownie" - Reset quiz and go back to restart
  void _handleTryAgain(BuildContext context) {
    // Invalidate the quiz controller to reset state
    ref.invalidate(quizControllerProvider);
    
    // Pop back to the quiz start page (which will reload questions)
    Navigator.of(context).pop();
  }
  
  /// "Udostępnij" - Share result text using share_plus
  Future<void> _handleShare(BuildContext context) async {
    final scoreText = widget.scorePercent.toStringAsFixed(0);
    final shareMessage = 'Zdobyłem $scoreText% w quizie "${widget.quizTitle}"! '
        'Sprawdź się w aplikacji Questest. 🎯';
    
    try {
      await Share.share(
        shareMessage,
        subject: 'Mój wynik w Questest',
      );
    } catch (e) {
      // Fallback to clipboard if sharing fails
      await Clipboard.setData(ClipboardData(text: shareMessage));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Skopiowano do schowka!'),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  /// "Ranking" - Navigate to ranking page
  void _handleRanking(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RankingPage(),
      ),
    );
  }

  /// "Pobierz PDF" - Generate and share PDF with results
  Future<void> _handleDownloadPdf(BuildContext context) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Generowanie PDF...'),
            ],
          ),
          duration: Duration(seconds: 10),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      final pdfBytes = await PdfService.generateQuizResultPdf(
        quizTitle: widget.quizTitle,
        scorePercent: widget.scorePercent,
        correctAnswers: widget.correctAnswers,
        totalQuestions: widget.totalQuestions,
        completedAt: DateTime.now(),
      );

      // Hide the loading snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Show bottom sheet with options
      if (context.mounted) {
        await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _PdfOptionsSheet(
            pdfBytes: pdfBytes,
            quizTitle: widget.quizTitle,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd generowania PDF: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double safePercent = widget.scorePercent.clamp(0, 100).toDouble();
    final incorrect = max(widget.totalQuestions - widget.correctAnswers, 0);
    final message = _buildMessage(safePercent);

    // Watch the submit result provider
    final submitParams = SubmitQuizResultParams(
      quizId: widget.quizId,
      scorePercentage: widget.scorePercent,
    );
    final submitResultAsync = ref.watch(submitQuizResultProvider(submitParams));

    // Listen to submit result changes and show feedback
    ref.listen(submitQuizResultProvider(submitParams), (previous, next) {
      next.when(
        data: (_) {
          // Success - show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wynik zapisany pomyślnie'),
              backgroundColor: AppTheme.successColor,
              duration: Duration(seconds: 2),
            ),
          );
        },
        error: (error, stackTrace) {
          // Error - show snackbar with retry button
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error is AppException 
                  ? error.message 
                  : 'Nie udało się zapisać wyniku'),
              backgroundColor: AppTheme.errorColor,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Ponów',
                textColor: Colors.white,
                onPressed: () {
                  ref.invalidate(submitQuizResultProvider(submitParams));
                },
              ),
            ),
          );
        },
        loading: () {
          // Loading state - could show a subtle indicator if needed
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twój wynik'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 64, // Account for padding
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ===== TOP SECTION: Score & Message =====
                    Column(
                      children: [
                        // Percentage - Bigger and bolder
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${safePercent.toStringAsFixed(0)}%',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            // Subtle loading indicator when saving
                            if (submitResultAsync.isLoading) ...[
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Correct/Total count
                        Text(
                          'Poprawne: ${widget.correctAnswers} / ${widget.totalQuestions}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _MessageCard(message: message),
                      ],
                    ),
                    
                    // ===== MIDDLE SECTION: Donut Chart =====
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: _DonutChart(
                        scorePercent: safePercent,
                        correct: widget.correctAnswers,
                        incorrect: incorrect,
                      ),
                    ),
                    
                    // ===== BOTTOM SECTION: Buttons =====
                    Column(
                      children: [
                        // Main action button - full width
                        SizedBox(
                          width: double.infinity,
                          child: QPrimaryButton(
                            text: 'Spróbuj ponownie',
                            icon: Icons.refresh,
                            onPressed: () => _handleTryAgain(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // PDF Download button
                        SizedBox(
                          width: double.infinity,
                          child: QSecondaryButton(
                            text: 'Pobierz PDF z wynikami',
                            icon: Icons.picture_as_pdf,
                            onPressed: () => _handleDownloadPdf(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Secondary actions - side by side
                        Row(
                          children: [
                            Expanded(
                              child: QSecondaryButton(
                                text: 'Udostępnij',
                                icon: Icons.share,
                                onPressed: () => _handleShare(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: QSecondaryButton(
                                text: 'Ranking',
                                icon: Icons.emoji_events,
                                onPressed: () => _handleRanking(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppTheme.surfaceColor,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.accentColor.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_emotions_outlined,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({
    required this.scorePercent,
    required this.correct,
    required this.incorrect,
  });

  final double scorePercent;
  final int correct;
  final int incorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double remainingPercent = (100 - scorePercent).toDouble();

    return Center(
      child: SizedBox(
        height: 230,
        width: 230,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
                sections: [
                  PieChartSectionData(
                    value: scorePercent,
                    color: AppTheme.primaryColor,
                    title: scorePercent > 5 ? '${scorePercent.toStringAsFixed(0)}%' : '',
                    radius: 90,
                    titleStyle: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PieChartSectionData(
                    value: remainingPercent,
                    color: AppTheme.dividerColor,
                    title: remainingPercent > 5 ? '${remainingPercent.toStringAsFixed(0)}%' : '',
                    radius: 90,
                    titleStyle: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                pieTouchData: PieTouchData(enabled: false),
              ),
            ),
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$correct / ${correct + incorrect}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Poprawne',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _buildMessage(double score) {
  if (score >= 90) {
    return 'Gdybyś był pieczywem, byłbyś chrupiącą bagietką! 🥖 Doskonały wynik.';
  } else if (score >= 75) {
    return 'Solidny wynik! Jak świeży croissant – lekkość i forma. 🥐';
  } else if (score >= 60) {
    return 'Całkiem nieźle – jak porządna grahamka. Trochę pracy i będzie top. 🥯';
  } else if (score >= 40) {
    return 'Jesteś na dobrej drodze. Jeszcze kilka wypieków i będzie idealnie. 🍞';
  }
  return 'Początki są najważniejsze. Zbudujmy razem solidny zakwas. 🍞';
}

/// Bottom sheet with PDF options (share/print)
class _PdfOptionsSheet extends StatelessWidget {
  const _PdfOptionsSheet({
    required this.pdfBytes,
    required this.quizTitle,
  });

  final Uint8List pdfBytes;
  final String quizTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = 'questest_wynik_${DateTime.now().millisecondsSinceEpoch}.pdf';

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Text(
            'PDF wygenerowany!',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Co chcesz zrobić z plikiem?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Share option
          _OptionTile(
            icon: Icons.share,
            title: 'Udostępnij',
            subtitle: 'Wyślij PDF do znajomych lub zapisz',
            color: AppTheme.primaryColor,
            onTap: () async {
              Navigator.pop(context);
              await PdfService.sharePdf(pdfBytes, fileName);
            },
          ),
          const SizedBox(height: 12),

          // Print option
          _OptionTile(
            icon: Icons.print,
            title: 'Drukuj / Podgląd',
            subtitle: 'Zobacz podgląd lub wydrukuj dokument',
            color: AppTheme.accentColor,
            onTap: () async {
              Navigator.pop(context);
              try {
                await PdfService.printPdf(pdfBytes, fileName);
              } catch (e) {
                // If printing fails (e.g., hot reload), fall back to share
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Drukowanie niedostępne. Użyj opcji Udostępnij.'),
                      backgroundColor: AppTheme.warningColor,
                      action: SnackBarAction(
                        label: 'Udostępnij',
                        textColor: Colors.white,
                        onPressed: () async {
                          await PdfService.sharePdf(pdfBytes, fileName);
                        },
                      ),
                    ),
                  );
                }
              }
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

