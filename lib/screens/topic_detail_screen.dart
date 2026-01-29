import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../models/models.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

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
                final appState = context.read<AppState>();
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
    final verses = ContentData.getByTopic(topic.id);

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
                  const SizedBox(width: 8),
                  Text(
                    topic.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      topic.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${verses.length} items',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content list
            Expanded(
              child: verses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            topic.icon,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No content yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Content for this topic\nwill be added soon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Consumer<AppState>(
                      builder: (context, appState, _) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: verses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final verse = verses[index];
                            final displayText = appState.getDisplayText(verse);
                            final isFavorite =
                                appState.isFavorite(verse.id);
                            final isBookmarked = appState.isInAnyCollection(verse.id);

                            return _VerseCard(
                              text: displayText,
                              reference: verse.reference,
                              isFavorite: isFavorite,
                              isBookmarked: isBookmarked,
                              onFavoriteToggle: () =>
                                  appState.toggleFavorite(verse.id),
                              onBookmarkTap: () =>
                                  _showAddToCollectionSheet(context, verse.id),
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

class _VerseCard extends StatelessWidget {
  final String text;
  final String? reference;
  final bool isFavorite;
  final bool isBookmarked;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBookmarkTap;

  const _VerseCard({
    required this.text,
    this.reference,
    required this.isFavorite,
    required this.isBookmarked,
    required this.onFavoriteToggle,
    required this.onBookmarkTap,
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
                onTap: () {
                  // TODO: Share functionality
                },
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
