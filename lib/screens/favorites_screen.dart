import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import 'share_sheet.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, size: 28),
                  ),
                  const Expanded(
                    child: Text(
                      'Favorites',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search favorites',
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
            const SizedBox(height: 16),

            // Favorites list
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  var favorites = appState.getFavoriteVerses();

                  // Filter by search query
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    favorites = favorites.where((verse) {
                      final text = appState.getDisplayText(verse).toLowerCase();
                      final reference = (verse.reference ?? '').toLowerCase();
                      return text.contains(query) || reference.contains(query);
                    }).toList();
                  }
                  
                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: AppTheme.secondaryText.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on quotes\nyou want to save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final verse = favorites[index];
                      final displayText = appState.getDisplayText(verse);

                      return _FavoriteCard(
                        text: displayText,
                        reference: verse.reference,
                        date: DateTime.now(), // In real app, store save date
                        isFavorite: true,
                        onFavoriteToggle: () => appState.toggleFavorite(verse.id),
                        onShare: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ShareSheet(
                              text: displayText,
                              reference: verse.reference,
                              theme: appState.currentTheme,
                            ),
                          );
                        },
                        onCollection: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final String text;
  final String? reference;
  final DateTime date;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShare;
  final VoidCallback onCollection;

  const _FavoriteCard({
    required this.text,
    this.reference,
    required this.date,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onShare,
    required this.onCollection,
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
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (reference != null) ...[
            const SizedBox(height: 8),
            Text(
              reference!,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.secondaryText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                DateFormat('EEE, MMM d, yyyy').format(date),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryText,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 22,
                  color: isFavorite ? Colors.red : AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onCollection,
                child: const Icon(
                  Icons.bookmark_border,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onShare,
                child: const Icon(
                  Icons.ios_share,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
