import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/models.dart';

class MyQuotesScreen extends StatefulWidget {
  const MyQuotesScreen({super.key});

  @override
  State<MyQuotesScreen> createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  void _showAddQuoteDialog() {
    final textController = TextEditingController();
    final sourceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Add Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your quote...',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: sourceController,
              decoration: const InputDecoration(
                hintText: 'Source (optional)',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                context.read<AppState>().addCustomQuote(
                      textController.text.trim(),
                      sourceController.text.trim().isEmpty
                          ? null
                          : sourceController.text.trim(),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
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
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, size: 28),
        ),
        title: const Text(
          'My Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddQuoteDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final quotes = appState.customQuotes;

          if (quotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 64,
                    color: AppTheme.secondaryText.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No quotes yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your own inspiring quotes',
                    style: TextStyle(
                      color: AppTheme.secondaryText.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddQuoteDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Quote'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryText,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return _QuoteCard(
                quote: quote,
                onDelete: () {
                  appState.removeCustomQuote(quote.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final CustomQuote quote;
  final VoidCallback onDelete;

  const _QuoteCard({
    required this.quote,
    required this.onDelete,
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
              const Text(
                '"',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent,
                  height: 0.8,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  quote.text,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Quote?'),
                      content: const Text('Are you sure you want to delete this quote?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppTheme.secondaryText.withOpacity(0.5),
                ),
              ),
            ],
          ),
          if (quote.source != null) ...[
            const SizedBox(height: 12),
            Text(
              '— ${quote.source}',
              style: TextStyle(
                color: AppTheme.secondaryText.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
