import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class ShareSheet extends StatelessWidget {
  final String text;
  final String? reference;

  const ShareSheet({
    super.key,
    required this.text,
    this.reference,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final theme = appState.currentTheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.secondaryText.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Close button
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ),
          ),
          
          // Preview card
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: theme.gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textColor,
                        height: 1.5,
                      ),
                    ),
                    if (reference != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        reference!,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textColor.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          
          // Action buttons row 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.download,
                  label: 'Save\nvideo',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saving...')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.copy,
                  label: 'Copy\ntext',
                  onTap: () {
                    final fullText = reference != null
                        ? '$text\n\n— $reference'
                        : text;
                    Clipboard.setData(ClipboardData(text: fullText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.bookmark_border,
                  label: 'Add to\ncollection',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide\nwatermark',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.volume_up_outlined,
                  label: 'Read\naloud',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Share buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ShareButton(
                  icon: Icons.chat_bubble,
                  label: 'Messages',
                  color: Colors.green,
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram\nStories',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
                  ),
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
                  ),
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.ios_share,
                  label: 'Share to...',
                  color: AppTheme.secondaryText,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final LinearGradient? gradient;
  final VoidCallback onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    this.color,
    this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: gradient == null ? color : null,
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
