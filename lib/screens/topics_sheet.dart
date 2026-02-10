import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../widgets/common_widgets.dart';
import '../models/models.dart';
import 'favorites_screen.dart';
import 'topic_detail_screen.dart';
import 'collections_screen.dart';
import 'my_quotes_screen.dart';
import 'history_screen.dart';

class TopicsSheet extends StatefulWidget {
  const TopicsSheet({super.key});

  @override
  State<TopicsSheet> createState() => _TopicsSheetState();
}

class _TopicsSheetState extends State<TopicsSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Topic> _filterTopics(List<Topic> topics) {
    if (_searchQuery.isEmpty) return topics;
    final query = _searchQuery.toLowerCase();
    return topics.where((topic) {
      return topic.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedTopics = ContentData.getTopicsGrouped();
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                    const Expanded(
                      child: Text(
                        'Explore topics',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search topics',
                        hintStyle: TextStyle(
                          color: AppTheme.secondaryText.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: AppTheme.secondaryText.withOpacity(0.5),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppTheme.secondaryText.withOpacity(0.5),
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: AppTheme.cardBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick access grid
                    Consumer<AppState>(
                      builder: (context, appState, _) {
                        final selectedTopics = appState.user.selectedTopics;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _QuickAccessCard(
                                    title: 'Favorites',
                                    icon: Icons.favorite_border,
                                    isFollowing: selectedTopics.contains('favorites'),
                                    onTap: () {
                                      Navigator.pop(context);
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
                                    isFollowing: selectedTopics.contains('my_own_quotes'),
                                    onTap: () {
                                      Navigator.pop(context);
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
                                    isFollowing: selectedTopics.contains('collections'),
                                    onTap: () {
                                      Navigator.pop(context);
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
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Topics by category
                    ...groupedTopics.entries.map((entry) {
                      final filteredTopics = _filterTopics(entry.value);
                      if (filteredTopics.isEmpty) {
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
                          ...filteredTopics.map((topic) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _TopicListItem(
                                name: topic.name,
                                icon: topic.icon,
                                isPremium: topic.isPremium,
                                onTap: () async {
                                  if (!topic.isPremium) {
                                    // Get the parent context before popping
                                    final parentContext = Navigator.of(context).context;
                                    Navigator.pop(context);
                                    await Navigator.push(
                                      parentContext,
                                      MaterialPageRoute(
                                        builder: (_) => TopicDetailScreen(topic: topic),
                                      ),
                                    );
                                    // Reopen TopicsSheet after returning
                                    if (parentContext.mounted) {
                                      showModalBottomSheet(
                                        context: parentContext,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => const TopicsSheet(),
                                      );
                                    }
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
        );
      },
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPremium;
  final bool isFollowing;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.icon,
    this.isPremium = false,
    this.isFollowing = false,
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
                  ),
                ),
                const Spacer(),
                Icon(
                  icon,
                  color: AppTheme.secondaryText,
                ),
              ],
            ),
            if (isPremium)
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.lock,
                  size: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            if (isFollowing)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
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
