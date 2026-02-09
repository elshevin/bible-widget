import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../models/models.dart';

class TopicsFollowScreen extends StatefulWidget {
  const TopicsFollowScreen({super.key});

  @override
  State<TopicsFollowScreen> createState() => _TopicsFollowScreenState();
}

class _TopicsFollowScreenState extends State<TopicsFollowScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Topics you follow',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: AppTheme.secondaryText.withOpacity(0.5),
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: AppTheme.secondaryText.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Following section - Quick access items
                      _FollowingSection(
                        items: [
                          _FollowItem(
                            title: 'General',
                            isFollowing: true,
                            onToggle: () {},
                          ),
                          _FollowItem(
                            title: 'Favorites',
                            isFollowing: true,
                            onToggle: () {},
                          ),
                          _FollowItem(
                            title: 'My own quotes',
                            isFollowing: true,
                            onToggle: () {},
                          ),
                          _FollowItem(
                            title: 'History',
                            isFollowing: true,
                            onToggle: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // By type section
                      _TopicSection(
                        title: 'By type',
                        topics: [
                          _TopicFollowItem(
                            name: 'Bible verses',
                            isFollowing: appState.user.selectedTopics.contains('bible_verses'),
                            isPremium: false,
                            onToggle: () => appState.toggleTopic('bible_verses'),
                          ),
                          _TopicFollowItem(
                            name: 'Prayers',
                            isFollowing: appState.user.selectedTopics.contains('prayers'),
                            isPremium: false,
                            onToggle: () => appState.toggleTopic('prayers'),
                          ),
                          _TopicFollowItem(
                            name: 'Quotes',
                            isFollowing: appState.user.selectedTopics.contains('quotes'),
                            isPremium: false,
                            onToggle: () => appState.toggleTopic('quotes'),
                          ),
                          _TopicFollowItem(
                            name: 'Affirmations',
                            isFollowing: appState.user.selectedTopics.contains('affirmations'),
                            isPremium: false,
                            onToggle: () => appState.toggleTopic('affirmations'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Topics by category
                      ...groupedTopics.entries.where((e) => e.key != 'By type').map((entry) {
                        final filteredTopics = _filterTopics(entry.value);
                        if (filteredTopics.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TopicSection(
                              title: entry.key,
                              topics: filteredTopics.map((topic) {
                                return _TopicFollowItem(
                                  name: topic.name,
                                  isFollowing: appState.user.selectedTopics.contains(topic.id),
                                  isPremium: topic.isPremium,
                                  onToggle: () => appState.toggleTopic(topic.id),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Topic> _filterTopics(List<Topic> topics) {
    if (_searchQuery.isEmpty) return topics;
    final query = _searchQuery.toLowerCase();
    return topics.where((topic) {
      return topic.name.toLowerCase().contains(query);
    }).toList();
  }
}

class _FollowingSection extends StatelessWidget {
  final List<_FollowItem> items;

  const _FollowingSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.secondaryText.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppTheme.secondaryText.withOpacity(0.1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _FollowItem {
  final String title;
  final bool isFollowing;
  final VoidCallback onToggle;

  const _FollowItem({
    required this.title,
    required this.isFollowing,
    required this.onToggle,
  });
}

class _TopicSection extends StatelessWidget {
  final String title;
  final List<_TopicFollowItem> topics;

  const _TopicSection({
    required this.title,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Follow all functionality
              },
              child: Text(
                'Follow all',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: topics.asMap().entries.map((entry) {
              final index = entry.key;
              final topic = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                topic.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (topic.isPremium) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: AppTheme.secondaryText.withOpacity(0.5),
                                ),
                              ],
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: topic.onToggle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: topic.isFollowing
                                  ? AppTheme.cardBackground
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.secondaryText.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              topic.isFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < topics.length - 1)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppTheme.secondaryText.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TopicFollowItem {
  final String name;
  final bool isFollowing;
  final bool isPremium;
  final VoidCallback onToggle;

  const _TopicFollowItem({
    required this.name,
    required this.isFollowing,
    this.isPremium = false,
    required this.onToggle,
  });
}
