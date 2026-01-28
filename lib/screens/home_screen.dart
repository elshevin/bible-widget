import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool _showStreakBanner = true;

  @override
  void initState() {
    super.initState();
    // Hide streak banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showStreakBanner = false);
      }
    });
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

        return Scaffold(
          body: Stack(
            children: [
              // Main Feed
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: feedContent.length,
                onPageChanged: (index) => appState.setFeedIndex(index),
                itemBuilder: (context, index) {
                  final verse = feedContent[index];
                  final displayText = appState.getDisplayText(verse);
                  final isFavorite = appState.isFavorite(verse.id);

                  return _VerseCard(
                    text: displayText,
                    reference: verse.reference,
                    gradient: currentTheme.gradient,
                    textColor: currentTheme.textColor,
                    isFavorite: isFavorite,
                    onFavorite: () => appState.toggleFavorite(verse.id),
                    onShare: () => _showShareSheet(displayText, verse.reference),
                    backgroundImage: currentTheme.backgroundImage,
                  );
                },
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
                        final verse = appState.currentVerse;
                        if (verse != null) {
                          _showShareSheet(
                            appState.getDisplayText(verse),
                            verse.reference,
                          );
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
                    Consumer<AppState>(
                      builder: (context, state, _) {
                        final verse = state.currentVerse;
                        final isFavorite = verse != null && state.isFavorite(verse.id);

                        return GestureDetector(
                          onTap: () {
                            if (verse != null) {
                              final justReachedLimit = state.toggleFavorite(verse.id);
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VerseCard extends StatelessWidget {
  final String text;
  final String? reference;
  final LinearGradient gradient;
  final Color textColor;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final String? backgroundImage;

  const _VerseCard({
    required this.text,
    this.reference,
    required this.gradient,
    required this.textColor,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundImage == null ? gradient : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image if available
          if (backgroundImage != null)
            Image.asset(
              backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to gradient if image fails to load
                return Container(
                  decoration: BoxDecoration(gradient: gradient),
                );
              },
            ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      height: 1.5,
                      shadows: backgroundImage != null
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
                      reference!,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                        shadows: backgroundImage != null
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
                  const Spacer(),
                  const SizedBox(height: 120), // Space for bottom UI
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
