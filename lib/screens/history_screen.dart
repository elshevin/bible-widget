import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'History',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  final history = appState.readingHistory;

                  if (history.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length + 1, // +1 for "See older quotes" button
                    itemBuilder: (context, index) {
                      if (index == history.length) {
                        return _buildSeeOlderButton();
                      }

                      final entry = history[index];
                      final verse = appState.getVerseById(entry.verseId);
                      if (verse == null) return const SizedBox.shrink();

                      return _HistoryItem(
                        verse: verse,
                        viewedAt: entry.viewedAt,
                        displayText: appState.getDisplayText(verse),
                        isFavorite: appState.isFavorite(verse.id),
                        isBookmarked: appState.isInAnyCollection(verse.id),
                        onFavorite: () => appState.toggleFavorite(verse.id),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your reading history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeOlderButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryText,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Text(
            'See older quotes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Verse verse;
  final DateTime viewedAt;
  final String displayText;
  final bool isFavorite;
  final bool isBookmarked;
  final VoidCallback onFavorite;

  const _HistoryItem({
    required this.verse,
    required this.viewedAt,
    required this.displayText,
    required this.isFavorite,
    required this.isBookmarked,
    required this.onFavorite,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (dateOnly == yesterday) {
      return 'Yesterday';
    }

    // Format: Mon, 2 Feb 2026
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _formatDate(viewedAt),
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.secondaryText,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onFavorite,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 22,
                  color: isFavorite ? Colors.red : AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 22,
                color: AppTheme.primaryText,
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.share,
                size: 22,
                color: AppTheme.primaryText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
