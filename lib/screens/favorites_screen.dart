import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
                  Row(
                    children: [
                      const Icon(Icons.swap_vert, size: 24),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppTheme.secondaryText.withOpacity(0.5),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: AppTheme.secondaryText.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Show all in feed button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Show all in feed'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Favorites list
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  final favorites = appState.getFavoriteVerses();
                  
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
                        onShare: () {},
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
