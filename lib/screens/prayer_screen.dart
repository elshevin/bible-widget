import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/content_data.dart';
import '../models/models.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  Prayer? _currentPrayer;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _currentPrayer = ContentData.prayers.first;
  }

  void _generatePrayer() async {
    setState(() => _isGenerating = true);
    
    // Simulate generation delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final prayers = ContentData.prayers;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % prayers.length;
    
    setState(() {
      _currentPrayer = prayers[randomIndex];
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final userName = appState.user.name;
    final theme = appState.currentTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: theme.gradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: theme.textColor,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Today\'s Prayer',
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40), // Balance
                  ],
                ),
              ),
              
              // Prayer content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentPrayer != null) ...[
                        // Prayer title
                        Text(
                          _currentPrayer!.title.replaceAll('{name}', userName ?? 'You'),
                          style: TextStyle(
                            color: theme.textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Prayer content
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isGenerating
                              ? SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: theme.textColor,
                                    ),
                                  ),
                                )
                              : Text(
                                  _currentPrayer!.getDisplayContent(userName),
                                  key: ValueKey(_currentPrayer!.id),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.textColor,
                                    fontSize: 18,
                                    height: 1.6,
                                  ),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Bottom actions
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  children: [
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ActionButton(
                          icon: Icons.ios_share,
                          color: theme.textColor,
                          onTap: () {},
                        ),
                        const SizedBox(width: 24),
                        _ActionButton(
                          icon: Icons.favorite_border,
                          color: theme.textColor,
                          onTap: () {},
                        ),
                        const SizedBox(width: 24),
                        _ActionButton(
                          icon: Icons.copy,
                          color: theme.textColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Generate button
                    GestureDetector(
                      onTap: _isGenerating ? null : _generatePrayer,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: theme.textColor,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: theme.gradient.colors.first,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Generate new prayer',
                              style: TextStyle(
                                color: theme.gradient.colors.first,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
