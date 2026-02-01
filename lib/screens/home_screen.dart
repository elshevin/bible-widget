import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';
import 'topics_screen.dart';
import 'themes_sheet.dart';
import 'profile_sheet.dart';
import 'share_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showStreakBanner = true;

  // Drag-based animation state
  double _dragOffset = 0;
  bool _isTransitioning = false;
  late AnimationController _exitController;
  late AnimationController _enterController;
  double _animatedOffset = 0;
  double _opacity = 1.0;

  // Animation values for smooth transitions (nullable until first use)
  Animation<double>? _exitAnimation;
  Animation<double>? _enterAnimation;
  Animation<double>? _exitOpacity;
  Animation<double>? _enterOpacity;

  @override
  void initState() {
    super.initState();
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _enterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Hide streak banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showStreakBanner = false);
      }
    });
  }

  @override
  void dispose() {
    _exitController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isTransitioning) return;
    setState(() {
      _dragOffset += details.delta.dy;
      // Calculate opacity based on drag distance
      _opacity = (1.0 - (_dragOffset.abs() / 350)).clamp(0.3, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details, AppState appState) {
    if (_isTransitioning) return;

    final threshold = 80.0;
    final velocity = details.primaryVelocity ?? 0;
    final feedContent = appState.feedContent;
    final currentIndex = appState.currentFeedIndex;

    // Determine direction: negative drag (swipe up) = next, positive drag (swipe down) = previous
    final direction = _dragOffset < 0 ? 1 : -1;
    final nextIndex = currentIndex + direction;

    // Check if we should switch verses
    final shouldSwitch = (_dragOffset.abs() > threshold || velocity.abs() > 500) &&
        nextIndex >= 0 &&
        nextIndex < feedContent.length;

    if (shouldSwitch) {
      _animateToNextVerse(direction, appState);
    } else {
      _animateBack();
    }
  }

  void _animateToNextVerse(int direction, AppState appState) {
    _isTransitioning = true;
    final screenHeight = MediaQuery.of(context).size.height;

    // Old content slides in the direction of the swipe
    // Swipe up (direction=1) => content goes UP (negative)
    // Swipe down (direction=-1) => content goes DOWN (positive)
    final exitTargetOffset = direction > 0 ? -screenHeight * 0.5 : screenHeight * 0.5;
    final startOffset = _dragOffset;
    final startOpacity = _opacity;

    // Setup exit animation
    _exitAnimation = Tween<double>(
      begin: startOffset,
      end: exitTargetOffset,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeOut));

    _exitOpacity = Tween<double>(
      begin: startOpacity,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeOut));

    void exitListener() {
      setState(() {
        _animatedOffset = _exitAnimation!.value - startOffset;
        _opacity = _exitOpacity!.value;
      });
    }

    _exitController.addListener(exitListener);
    _exitController.forward(from: 0).then((_) {
      _exitController.removeListener(exitListener);

      // Switch to next verse
      final nextIndex = appState.currentFeedIndex + direction;
      appState.setFeedIndex(nextIndex);

      // Add to reading history
      final currentVerse = appState.currentVerse;
      if (currentVerse != null) {
        appState.addToHistory(currentVerse.id);
      }

      // New content comes from the opposite direction
      // If old went UP, new comes from BOTTOM
      // If old went DOWN, new comes from TOP
      final enterStartOffset = direction > 0 ? screenHeight * 0.4 : -screenHeight * 0.4;

      // Setup enter animation
      _enterAnimation = Tween<double>(
        begin: enterStartOffset,
        end: 0.0,
      ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic));

      _enterOpacity = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOut));

      // Set initial state for new content
      _dragOffset = 0;
      _animatedOffset = enterStartOffset;
      _opacity = 0.0;

      void enterListener() {
        setState(() {
          _animatedOffset = _enterAnimation!.value;
          _opacity = _enterOpacity!.value;
        });
      }

      _enterController.addListener(enterListener);
      _enterController.forward(from: 0).then((_) {
        _enterController.removeListener(enterListener);
        setState(() {
          _dragOffset = 0;
          _animatedOffset = 0;
          _opacity = 1.0;
          _isTransitioning = false;
        });
      });
    });
  }

  void _animateBack() {
    _isTransitioning = true;
    final startOffset = _dragOffset;
    final startOpacity = _opacity;

    _exitAnimation = Tween<double>(
      begin: startOffset,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeOut));

    _exitOpacity = Tween<double>(
      begin: startOpacity,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeOut));

    void bounceListener() {
      setState(() {
        _dragOffset = _exitAnimation!.value;
        _animatedOffset = 0;
        _opacity = _exitOpacity!.value;
      });
    }

    _exitController.addListener(bounceListener);
    _exitController.forward(from: 0).then((_) {
      _exitController.removeListener(bounceListener);
      setState(() {
        _dragOffset = 0;
        _animatedOffset = 0;
        _opacity = 1.0;
        _isTransitioning = false;
      });
    });
  }

  void _showTopicsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TopicsScreen(),
      ),
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
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: (details) => _onDragEnd(details, appState),
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

                // Animated Text Content - follows finger drag
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Transform.translate(
                          offset: Offset(0, _dragOffset + _animatedOffset),
                          child: Opacity(
                            opacity: _opacity,
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
                                // Share & Favorite buttons - move with content
                                const SizedBox(height: 40),
                                Row(
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
                              ],
                            ),
                          ),
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
                          onTap: _showTopicsScreen,
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

              ],
            ),
          ),
        );
      },
    );
  }
}
