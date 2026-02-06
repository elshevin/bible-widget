import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class ShareSheet extends StatefulWidget {
  final String text;
  final String? reference;
  final VisualTheme? theme;

  const ShareSheet({
    super.key,
    required this.text,
    this.reference,
    this.theme,
  });

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;

  Future<void> _shareImage() async {
    setState(() => _isSaving = true);
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/bible_verse_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: widget.reference != null
            ? '${widget.text}\n\n— ${widget.reference}'
            : widget.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveImage() async {
    setState(() => _isSaving = true);
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/bible_verse_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _shareText() async {
    final fullText = widget.reference != null
        ? '${widget.text}\n\n— ${widget.reference}'
        : widget.text;
    await Share.share(fullText);
  }

  @override
  Widget build(BuildContext context) {
    // Use passed theme, or try to read from context, or fallback to default
    VisualTheme theme;
    if (widget.theme != null) {
      theme = widget.theme!;
    } else {
      try {
        final appState = context.read<AppState>();
        theme = appState.currentTheme;
      } catch (e) {
        // Fallback to first theme if Provider not available
        theme = VisualThemes.all.first;
      }
    }

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
            child: Screenshot(
              controller: _screenshotController,
              child: Container(
                height: 350,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background: image if available, otherwise gradient
                    if (theme.hasBackgroundImage)
                      Image.asset(
                        theme.backgroundImage!,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: theme.gradient,
                        ),
                      ),
                    // Content overlay
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.textColor,
                                height: 1.5,
                              ),
                            ),
                            if (widget.reference != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                widget.reference!,
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
                  ],
                ),
              ),
            ),
          ),
          
          // Action buttons row 1
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.download,
                    label: 'Save\nimage',
                    onTap: _saveImage,
                  ),
                  _ActionButton(
                    icon: Icons.copy,
                    label: 'Copy\ntext',
                    onTap: () {
                      final fullText = widget.reference != null
                          ? '${widget.text}\n\n— ${widget.reference}'
                          : widget.text;
                      Clipboard.setData(ClipboardData(text: fullText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.text_fields,
                    label: 'Share\ntext',
                    onTap: _shareText,
                  ),
                  _ActionButton(
                    icon: Icons.image,
                    label: 'Share\nimage',
                    onTap: _shareImage,
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
                  onTap: _shareText,
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram\nStories',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
                  ),
                  onTap: _shareImage,
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
                  ),
                  onTap: _shareImage,
                ),
                const SizedBox(width: 16),
                _ShareButton(
                  icon: Icons.ios_share,
                  label: 'Share to...',
                  color: AppTheme.secondaryText,
                  onTap: _shareImage,
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
