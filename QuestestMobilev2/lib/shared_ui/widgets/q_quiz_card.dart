import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Quiz card component for displaying quiz information
/// Used in the home page quiz list - redesigned with beautiful placeholders
class QQuizCard extends StatelessWidget {
  /// Quiz ID for favorites
  final String? quizId;
  
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
  
  /// Whether this quiz is in favorites
  final bool isFavorite;
  
  /// Callback when favorite button is tapped
  final VoidCallback? onFavoriteToggle;

  const QQuizCard({
    super.key,
    this.quizId,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.questionCount,
    required this.participantsCount,
    this.onTap,
    this.difficulty,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image or Beautiful Placeholder
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Stats Row
                  Row(
                    children: [
                      // Question Count chip - show only if we have data
                      if (questionCount > 0)
                        _StatChip(
                          icon: Icons.quiz_outlined,
                          label: '$questionCount pytań',
                          color: AppTheme.primaryColor,
                        )
                      else
                        _StatChip(
                          icon: Icons.quiz_outlined,
                          label: 'Quiz',
                          color: AppTheme.primaryColor,
                        ),
                      const SizedBox(width: 10),
                      
                      // Participants Count chip - show only if we have data
                      if (participantsCount > 0)
                        _StatChip(
                          icon: Icons.people_outline,
                          label: _formatParticipants(participantsCount),
                          color: AppTheme.accentColor,
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
    final bool hasValidImage = thumbnailUrl.startsWith('http');
    
    return Stack(
      children: [
        // Image or Gradient Placeholder
        AspectRatio(
          aspectRatio: 16 / 9,
          child: hasValidImage
              ? Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildBeautifulPlaceholder(context);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingPlaceholder(context, loadingProgress);
                  },
                )
              : _buildBeautifulPlaceholder(context),
        ),
        
        // Gradient Overlay at bottom for better text readability
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        
        // Category badge on top left
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Quiz',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Favorite button on top right
        if (onFavoriteToggle != null)
          Positioned(
            top: 12,
            right: 12,
            child: _FavoriteButton(
              isFavorite: isFavorite,
              onTap: onFavoriteToggle!,
            ),
          ),
      ],
    );
  }

  Widget _buildBeautifulPlaceholder(BuildContext context) {
    // Generate deterministic colors based on title hash
    final hash = title.hashCode;
    final colorIndex = hash.abs() % _placeholderGradients.length;
    final patternIndex = hash.abs() % 4;
    final gradient = _placeholderGradients[colorIndex];
    
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Geometric pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _GeometricPatternPainter(
                patternType: patternIndex,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Center icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForTitle(title),
                size: 48,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context, ImageChunkEvent progress) {
    final value = progress.expectedTotalBytes != null
        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
        : null;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ładowanie...',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('geograf')) return Icons.public;
    if (lowerTitle.contains('histor')) return Icons.history_edu;
    if (lowerTitle.contains('matem')) return Icons.calculate;
    if (lowerTitle.contains('fizyk')) return Icons.science;
    if (lowerTitle.contains('chemi')) return Icons.science;
    if (lowerTitle.contains('biolog')) return Icons.biotech;
    if (lowerTitle.contains('język') || lowerTitle.contains('polski')) return Icons.translate;
    if (lowerTitle.contains('angiel') || lowerTitle.contains('english')) return Icons.language;
    if (lowerTitle.contains('informat')) return Icons.computer;
    if (lowerTitle.contains('muzyk')) return Icons.music_note;
    if (lowerTitle.contains('sztuk') || lowerTitle.contains('art')) return Icons.palette;
    if (lowerTitle.contains('sport')) return Icons.sports_soccer;
    if (lowerTitle.contains('film')) return Icons.movie;
    if (lowerTitle.contains('gra') || lowerTitle.contains('game')) return Icons.videogame_asset;
    return Icons.school;
  }

  Widget _buildDifficultyBadge(BuildContext context, String level) {
    Color badgeColor;
    IconData icon;
    switch (level.toLowerCase()) {
      case 'easy':
      case 'łatwy':
        badgeColor = AppTheme.successColor;
        icon = Icons.sentiment_satisfied;
        break;
      case 'medium':
      case 'średni':
        badgeColor = AppTheme.warningColor;
        icon = Icons.sentiment_neutral;
        break;
      case 'hard':
      case 'trudny':
        badgeColor = AppTheme.errorColor;
        icon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            level.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: badgeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
  
  // Beautiful gradient combinations for placeholders
  static const List<LinearGradient> _placeholderGradients = [
    // Purple to Pink
    LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFFFF6B9D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Teal to Blue
    LinearGradient(
      colors: [Color(0xFF00B894), Color(0xFF0984E3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Orange to Pink
    LinearGradient(
      colors: [Color(0xFFFDCB6E), Color(0xFFE17055)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Blue to Purple
    LinearGradient(
      colors: [Color(0xFF74B9FF), Color(0xFF6C5CE7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Green to Cyan
    LinearGradient(
      colors: [Color(0xFF55EFC4), Color(0xFF00CEC9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Rose to Orange
    LinearGradient(
      colors: [Color(0xFFFAB1A0), Color(0xFFE17055)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Indigo to Blue
    LinearGradient(
      colors: [Color(0xFF5758BB), Color(0xFF6A89CC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Pink to Purple
    LinearGradient(
      colors: [Color(0xFFE056FD), Color(0xFF6C5CE7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}

/// Small stat chip widget
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for geometric patterns
class _GeometricPatternPainter extends CustomPainter {
  final int patternType;
  final Color color;

  _GeometricPatternPainter({
    required this.patternType,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    switch (patternType) {
      case 0:
        _drawCirclePattern(canvas, size, paint);
        break;
      case 1:
        _drawDiamondPattern(canvas, size, paint);
        break;
      case 2:
        _drawWavePattern(canvas, size, paint);
        break;
      case 3:
        _drawDotPattern(canvas, size, paint);
        break;
    }
  }

  void _drawCirclePattern(Canvas canvas, Size size, Paint paint) {
    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 15, paint);
      }
    }
  }

  void _drawDiamondPattern(Canvas canvas, Size size, Paint paint) {
    for (double x = 20; x < size.width; x += 50) {
      for (double y = 20; y < size.height; y += 50) {
        final path = Path()
          ..moveTo(x, y - 15)
          ..lineTo(x + 15, y)
          ..lineTo(x, y + 15)
          ..lineTo(x - 15, y)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawWavePattern(Canvas canvas, Size size, Paint paint) {
    for (double y = 20; y < size.height; y += 30) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 20) {
        path.quadraticBezierTo(
          x + 10, y - 10,
          x + 20, y,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawDotPattern(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.fill;
    for (double x = 15; x < size.width; x += 25) {
      for (double y = 15; y < size.height; y += 25) {
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated favorite button widget
class _FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 22,
            color: widget.isFavorite ? Colors.red : Colors.grey[600],
          ),
        ),
      ),
    );
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
    final hash = title.hashCode;
    final colorIndex = hash.abs() % QQuizCard._placeholderGradients.length;
    final gradient = QQuizCard._placeholderGradients[colorIndex];

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                        return _buildCompactPlaceholder(gradient);
                      },
                    )
                  : _buildCompactPlaceholder(gradient),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 12,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$questionCount Q',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
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

  Widget _buildCompactPlaceholder(LinearGradient gradient) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Center(
        child: Icon(
          Icons.school,
          size: 40,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
