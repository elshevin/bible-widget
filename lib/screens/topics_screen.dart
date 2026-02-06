import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../models/models.dart';
import 'favorites_screen.dart';
import 'topic_detail_screen.dart';
import 'collections_screen.dart';
import 'my_quotes_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'topics_follow_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  Widget build(BuildContext context) {
    final groupedTopics = ContentData.getTopicsGrouped();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.cardBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Explore topics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.search,
                        size: 24,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TopicsFollowScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Unlock all banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Unlock all topics',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Browse topics and follow them to customize your feed',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primaryText.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            size: 40,
                            color: AppTheme.primaryText.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick access grid - 2x2
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessCard(
                          title: 'Favorites',
                          icon: Icons.favorite_border,
                          showCheckmark: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavoritesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessCard(
                          title: 'My own quotes',
                          icon: Icons.edit_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyQuotesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessCard(
                          title: 'Collections',
                          icon: Icons.bookmark_border,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CollectionsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessCard(
                          title: 'History',
                          icon: Icons.history,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // By type section
                  const Text(
                    'By type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Type items
                  _TypeListItem(
                    title: 'Bible verses',
                    icon: Icons.menu_book_outlined,
                    isPremium: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _TypeListItem(
                    title: 'Prayers',
                    icon: Icons.person_outline,
                    isPremium: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _TypeListItem(
                    title: 'Quotes',
                    icon: Icons.format_quote_outlined,
                    isPremium: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _TypeListItem(
                    title: 'Affirmations',
                    icon: Icons.chat_bubble_outline,
                    isPremium: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Topics by category
                  ...groupedTopics.entries.where((e) => e.key != 'By type').map((entry) {
                    final topics = entry.value;
                    if (topics.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...topics.map((topic) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _TopicListItem(
                              name: topic.name,
                              icon: topic.icon,
                              isPremium: topic.isPremium,
                              onTap: () {
                                if (!topic.isPremium) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TopicDetailScreen(topic: topic),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPremium;
  final bool showCheckmark;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.icon,
    this.isPremium = false,
    this.showCheckmark = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
              ],
            ),
            // Top right icon
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                icon,
                color: AppTheme.secondaryText,
                size: 22,
              ),
            ),
            // Bottom right - checkmark or lock
            if (showCheckmark)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryText,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              )
            else if (isPremium)
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.lock,
                  size: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPremium;
  final VoidCallback onTap;

  const _TypeListItem({
    required this.title,
    required this.icon,
    this.isPremium = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppTheme.primaryText),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isPremium)
              const Icon(
                Icons.lock,
                size: 18,
                color: AppTheme.secondaryText,
              ),
          ],
        ),
      ),
    );
  }
}

class _TopicListItem extends StatelessWidget {
  final String name;
  final String icon;
  final bool isPremium;
  final VoidCallback onTap;

  const _TopicListItem({
    required this.name,
    required this.icon,
    this.isPremium = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isPremium)
              const Icon(
                Icons.lock,
                size: 18,
                color: AppTheme.secondaryText,
              )
            else
              const Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryText,
              ),
          ],
        ),
      ),
    );
  }
}
