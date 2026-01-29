import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';
import 'topics_sheet.dart';
import 'themes_sheet.dart';
import 'profile_sheet.dart';
import 'share_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _showStreakBanner = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;
  int _direction = 1; // 1 for down, -1 for up

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Hide streak banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showStreakBanner = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToVerse(int direction, AppState appState) async {
    if (_isAnimating) return;

    final feedContent = appState.feedContent;
    final currentIndex = appState.currentFeedIndex;
    final nextIndex = currentIndex + direction;

    if (nextIndex < 0 || nextIndex >= feedContent.length) return;

    setState(() {
      _isAnimating = true;
      _direction = direction;
    });

    // Update slide direction based on swipe
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, direction * -0.1),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Animate out
    await _animationController.forward();

    // Change verse
    appState.setFeedIndex(nextIndex);

    // Reset and animate in from opposite direction
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, direction * 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.reset();
    await _animationController.forward();
    _animationController.reset();

    setState(() => _isAnimating = false);
  }

  void _showTopicsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TopicsSheet(),
    );
  }

  void _showThemesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ThemesSheet(),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProfileSheet(),
    );
  }

  void _showShareSheet(String verseText, String? reference) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareSheet(
        text: verseText,
        reference: reference,
      ),
    );
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.cardBackground,
        title: const Row(
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('Congratulations!'),
          ],
        ),
        content: const Text(
          'You\'ve completed today\'s reading goal!\n\nKeep up the great work on your spiritual journey.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final feedContent = appState.feedContent;
        final currentTheme = appState.currentTheme;
        final userName = appState.user.name;
        final streakCount = appState.user.streakCount;
        final favoritesCount = appState.favoritesCount;

        if (feedContent.isEmpty) {
          appState.initialize();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentVerse = appState.currentVerse;
        final displayText = currentVerse != null ? appState.getDisplayText(currentVerse) : '';
        final reference = currentVerse?.reference;
        final isFavorite = currentVerse != null && appState.isFavorite(currentVerse.id);

        return Scaffold(
          body: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < -100) {
                // Swipe up - next verse
                _navigateToVerse(1, appState);
              } else if (details.primaryVelocity! > 100) {
                // Swipe down - previous verse
                _navigateToVerse(-1, appState);
              }
            },
            child: Stack(
              children: [
                // Static Background (Image with optional Lottie overlay)
                Container(
                  decoration: BoxDecoration(
                    gradient: currentTheme.backgroundImage == null ? currentTheme.gradient : null,
                  ),
                  child: currentTheme.backgroundImage != null
                      ? Image.asset(
                          currentTheme.backgroundImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(gradient: currentTheme.gradient),
                            );
                          },
                        )
                      : null,
                ),

                // Lottie animation overlay for live themes
                if (currentTheme.lottieAsset != null)
                  Positioned.fill(
                    child: Lottie.asset(
                      currentTheme.lottieAsset!,
                      fit: BoxFit.cover,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                // Animated Text Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _isAnimating
                                    ? _fadeAnimation
                                    : const AlwaysStoppedAnimation(1.0),
                                child: Column(
                                  children: [
                                    Text(
                                      displayText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: currentTheme.textColor,
                                        height: 1.5,
                                        shadows: currentTheme.backgroundImage != null
                                            ? [
                                                Shadow(
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 4,
                                                  color: Colors.black.withOpacity(0.3),
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                    if (reference != null) ...[
                                      const SizedBox(height: 24),
                                      Text(
                                        reference,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: currentTheme.textColor.withOpacity(0.8),
                                          fontStyle: FontStyle.italic,
                                          shadows: currentTheme.backgroundImage != null
                                              ? [
                                                  Shadow(
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 3,
                                                    color: Colors.black.withOpacity(0.3),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        const SizedBox(height: 120), // Space for bottom UI
                      ],
                    ),
                  ),
                ),

                // Top bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Favorites progress
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                favoritesCount >= 5
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${min(favoritesCount, 5)}/5',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: (favoritesCount / 5).clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Premium button
                        GestureDetector(
                          onTap: () {
                            // Show premium sheet
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Streak banner
                if (_showStreakBanner)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'New streak started',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          StreakWidget(streakCount: streakCount),
                        ],
                      ),
                    ),
                  ),

                // Bottom bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      top: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Topics button
                        GestureDetector(
                          onTap: _showTopicsSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.grid_view_rounded,
                                  size: 20,
                                  color: AppTheme.primaryText,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'General',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryText,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8A0A0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Action buttons
                        Row(
                          children: [
                            // Themes button
                            GestureDetector(
                              onTap: _showThemesSheet,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.palette_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Profile button
                            GestureDetector(
                              onTap: _showProfileSheet,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Center action buttons (Share & Favorite)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 80,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Share
                      GestureDetector(
                        onTap: () {
                          if (currentVerse != null) {
                            _showShareSheet(displayText, reference);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.ios_share,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Favorite
                      GestureDetector(
                        onTap: () {
                          if (currentVerse != null) {
                            final justReachedLimit = appState.toggleFavorite(currentVerse.id);
                            if (justReachedLimit) {
                              _showCongratulationsDialog();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
