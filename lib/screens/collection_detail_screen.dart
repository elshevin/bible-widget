import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/models.dart';

class CollectionDetailScreen extends StatelessWidget {
  final Collection collection;

  const CollectionDetailScreen({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, size: 28),
        ),
        title: Text(
          collection.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          // Get the latest collection data
          final currentCollection = appState.collections.firstWhere(
            (c) => c.id == collection.id,
            orElse: () => collection,
          );

          if (currentCollection.verseIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: AppTheme.secondaryText.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No verses yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add verses from your favorites',
                    style: TextStyle(
                      color: AppTheme.secondaryText.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentCollection.verseIds.length,
            itemBuilder: (context, index) {
              final verseId = currentCollection.verseIds[index];
              final verse = appState.getVerseById(verseId);

              if (verse == null) {
                return const SizedBox.shrink();
              }

              return _VerseCard(
                verse: verse,
                onRemove: () {
                  appState.removeFromCollection(collection.id, verseId);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final Verse verse;
  final VoidCallback onRemove;

  const _VerseCard({
    required this.verse,
    required this.onRemove,
  });

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  verse.text,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: AppTheme.secondaryText.withOpacity(0.5),
                ),
              ),
            ],
          ),
          if (verse.reference != null) ...[
            const SizedBox(height: 12),
            Text(
              verse.reference!,
              style: TextStyle(
                color: AppTheme.secondaryText.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
