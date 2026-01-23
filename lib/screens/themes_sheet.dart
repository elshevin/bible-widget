import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class ThemesSheet extends StatelessWidget {
  const ThemesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.cardBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Unlock all',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Themes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(label: '+ Create', isSelected: false),
                          const SizedBox(width: 8),
                          _FilterChip(label: 'All', isSelected: true),
                          const SizedBox(width: 8),
                          _FilterChip(label: 'Plain', isSelected: false),
                          const SizedBox(width: 8),
                          _FilterChip(label: 'Popular', isSelected: false),
                          const SizedBox(width: 8),
                          _FilterChip(label: 'Jesus', isSelected: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Theme mixes section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Theme mixes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(color: AppTheme.primaryText),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _ThemeMixCard(
                            name: 'Nature',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF134e5e), Color(0xFF71b280)],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _ThemeMixCard(
                            name: 'Sunset',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2C1810), Color(0xFF8B6914)],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _ThemeMixCard(
                            name: 'Ocean',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // For you section
                    const Text(
                      'For you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Themes grid
                    Consumer<AppState>(
                      builder: (context, appState, _) {
                        final selectedThemeId = appState.user.selectedThemeId;
                        
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: VisualThemes.all.length,
                          itemBuilder: (context, index) {
                            final theme = VisualThemes.all[index];
                            return ThemePreviewCard(
                              name: theme.name,
                              gradient: theme.gradient,
                              isSelected: selectedThemeId == theme.id,
                              isPremium: theme.isPremium,
                              isVideo: theme.isVideo,
                              onTap: () {
                                if (!theme.isPremium) {
                                  appState.setTheme(theme.id);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryText : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.primaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ThemeMixCard extends StatelessWidget {
  final String name;
  final LinearGradient gradient;

  const _ThemeMixCard({
    required this.name,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
