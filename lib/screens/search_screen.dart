import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/content_data.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../services/analytics_service.dart';
import 'topic_detail_screen.dart';
import 'share_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Search suggestions
  final List<String> _suggestions = [
    'Verses',
    'Prayers',
    'God',
    'Blessed',
    'Love',
    'Faith',
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('search');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Topic> _getFilteredTopics() {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    // Get all topics from grouped data
    final groupedTopics = ContentData.getTopicsGrouped();
    final allTopics = <Topic>[];
    for (final topics in groupedTopics.values) {
      allTopics.addAll(topics);
    }
    return allTopics.where((topic) {
      return topic.name.toLowerCase().contains(query);
    }).toList();
  }

  void _showAddToCollectionSheet(BuildContext context, String verseId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Consumer<AppState>(
          builder: (context, appState, _) {
            final collections = appState.collections;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add to Collection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (collections.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 48,
                          color: AppTheme.secondaryText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No collections yet',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...collections.map((collection) {
                    final isInCollection = collection.verseIds.contains(verseId);
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isInCollection
                              ? AppTheme.accent.withOpacity(0.2)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isInCollection ? Icons.bookmark : Icons.bookmark_border,
                          color: isInCollection ? AppTheme.accent : Colors.grey,
                        ),
                      ),
                      title: Text(collection.name),
                      subtitle: Text('${collection.verseIds.length} verses'),
                      trailing: isInCollection
                          ? const Icon(Icons.check_circle, color: AppTheme.accent)
                          : null,
                      onTap: () {
                        if (isInCollection) {
                          appState.removeFromCollection(collection.id, verseId);
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed from "${collection.name}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          appState.addToCollection(collection.id, verseId);
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to "${collection.name}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  }),
                const Divider(),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, color: AppTheme.accent),
                  ),
                  title: const Text('Create new collection'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showCreateCollectionDialog(context, verseId);
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, String verseId) {
    final controller = TextEditingController();
    final appState = Provider.of<AppState>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Create Collection'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Collection name',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                appState.createCollection(controller.text.trim());
                final newCollection = appState.collections.last;
                appState.addToCollection(newCollection.id, verseId);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created "${controller.text.trim()}" and added verse'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Create & Add',
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

  List<Verse> _getFilteredVerses() {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    final verses = ContentData.getAllContent();
    return verses.where((verse) {
      return verse.text.toLowerCase().contains(query) ||
             verse.source.toLowerCase().contains(query);
    }).take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTopics = _getFilteredTopics();
    final filteredVerses = _getFilteredVerses();
    final hasResults = filteredTopics.isNotEmpty || filteredVerses.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          final results = _getFilteredTopics().length + _getFilteredVerses().length;
                          AnalyticsService.logSearch(value, results);
                        }
                      },
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search',
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
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildSuggestions()
                  : hasResults
                      ? _buildSearchResults(filteredTopics, filteredVerses)
                      : _buildNoResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...(_suggestions.map((suggestion) => _SuggestionItem(
            text: suggestion,
            onTap: () {
              _searchController.text = suggestion;
              setState(() => _searchQuery = suggestion);
            },
          ))),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Topic> topics, List<Verse> verses) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (topics.isNotEmpty) ...[
          const Text(
            'Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...topics.map((topic) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TopicResultItem(
              topic: topic,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopicDetailScreen(topic: topic),
                  ),
                );
              },
            ),
          )),
          const SizedBox(height: 24),
        ],
        if (verses.isNotEmpty) ...[
          const Text(
            'Verses & Quotes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Consumer<AppState>(
            builder: (context, appState, _) {
              return Column(
                children: verses.map((verse) {
                  final isFavorite = appState.isFavorite(verse.id);
                  final isBookmarked = appState.isInAnyCollection(verse.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _VerseResultItem(
                      verse: verse,
                      isFavorite: isFavorite,
                      isBookmarked: isBookmarked,
                      onFavoriteToggle: () {
                        appState.toggleFavorite(verse.id);
                        AnalyticsService.logFavoriteToggle(
                          verse.id,
                          !isFavorite,
                          source: 'search',
                        );
                      },
                      onBookmarkTap: () {
                        AnalyticsService.logButtonTap('search_bookmark');
                        _showAddToCollectionSheet(context, verse.id);
                      },
                      onShareTap: () {
                        AnalyticsService.logShare(
                          verse.id,
                          'share_sheet',
                          source: 'search',
                        );
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ShareSheet(
                            text: appState.getDisplayText(verse),
                            reference: verse.reference,
                            theme: appState.currentTheme,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.primaryText,
          ),
        ),
      ),
    );
  }
}

class _TopicResultItem extends StatelessWidget {
  final Topic topic;
  final VoidCallback onTap;

  const _TopicResultItem({
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(topic.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                topic.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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

class _VerseResultItem extends StatelessWidget {
  final Verse verse;
  final bool isFavorite;
  final bool isBookmarked;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;

  const _VerseResultItem({
    required this.verse,
    required this.isFavorite,
    required this.isBookmarked,
    required this.onFavoriteToggle,
    required this.onBookmarkTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verse.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            verse.source,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryText,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onFavoriteToggle,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 22,
                    color: isFavorite ? Colors.red : AppTheme.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBookmarkTap,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 22,
                    color: isBookmarked ? AppTheme.accent : AppTheme.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onShareTap,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.ios_share,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
