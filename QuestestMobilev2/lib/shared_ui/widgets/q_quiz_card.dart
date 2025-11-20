import 'package:flutter/material.dart';

/// Quiz card component for displaying quiz information
/// Used in the home page quiz list
class QQuizCard extends StatelessWidget {
  /// Quiz title
  final String title;
  
  /// Quiz subtitle/author
  final String subtitle;
  
  /// Thumbnail image URL
  final String thumbnailUrl;
  
  /// Number of questions in the quiz
  final int questionCount;
  
  /// Number of participants who took the quiz
  final int participantsCount;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;
  
  /// Optional difficulty badge
  final String? difficulty;

  const QQuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.questionCount,
    required this.participantsCount,
    this.onTap,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
            _buildThumbnail(context),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Stats Row
                  Row(
                    children: [
                      // Question Count
                      Icon(
                        Icons.quiz_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$questionCount Questions',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      
                      // Participants Count
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatParticipants(participantsCount),
                        style: theme.textTheme.bodySmall,
                      ),
                      
                      const Spacer(),
                      
                      // Difficulty Badge (if provided)
                      if (difficulty != null)
                        _buildDifficultyBadge(context, difficulty!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Stack(
      children: [
        // Image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: thumbnailUrl.startsWith('http')
              ? Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder(context);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholder(context);
                  },
                )
              : _buildPlaceholder(context),
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.quiz,
          size: 48,
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context, String level) {
    Color badgeColor;
    switch (level.toLowerCase()) {
      case 'easy':
        badgeColor = Colors.green;
        break;
      case 'medium':
        badgeColor = Colors.orange;
        break;
      case 'hard':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        level.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: badgeColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatParticipants(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// Compact version of quiz card for grid layouts
class QQuizCardCompact extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final int questionCount;
  final VoidCallback? onTap;

  const QQuizCardCompact({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.questionCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            AspectRatio(
              aspectRatio: 1,
              child: thumbnailUrl.startsWith('http')
                  ? Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.quiz,
                            size: 32,
                            color: theme.primaryColor.withOpacity(0.3),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: theme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.quiz,
                        size: 32,
                        color: theme.primaryColor.withOpacity(0.3),
                      ),
                    ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$questionCount Q',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
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

