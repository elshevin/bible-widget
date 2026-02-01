import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/content_data.dart';
import '../models/models.dart';
import 'topic_detail_screen.dart';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Topic> _getFilteredTopics() {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    final topics = ContentData.getAllTopics();
    return topics.where((topic) {
      return topic.name.toLowerCase().contains(query);
    }).toList();
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
            // Header with search bar
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
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
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
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
          ...verses.map((verse) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _VerseResultItem(verse: verse),
          )),
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

  const _VerseResultItem({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verse.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            verse.source,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
