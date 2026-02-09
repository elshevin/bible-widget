import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                // Add verse to the newly created collection
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
                    itemCount: history.length,
                    itemBuilder: (context, index) {
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
                        onBookmark: () {
                          _showAddToCollectionSheet(context, verse.id);
                        },
                        onShare: () {
                          Share.share(appState.getDisplayText(verse));
                        },
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

}

class _HistoryItem extends StatelessWidget {
  final Verse verse;
  final DateTime viewedAt;
  final String displayText;
  final bool isFavorite;
  final bool isBookmarked;
  final VoidCallback onFavorite;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const _HistoryItem({
    required this.verse,
    required this.viewedAt,
    required this.displayText,
    required this.isFavorite,
    required this.isBookmarked,
    required this.onFavorite,
    required this.onBookmark,
    required this.onShare,
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
              GestureDetector(
                onTap: onBookmark,
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 22,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onShare,
                child: const Icon(
                  Icons.share,
                  size: 22,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
