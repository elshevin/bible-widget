import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class ThemesSheet extends StatefulWidget {
  const ThemesSheet({super.key});

  @override
  State<ThemesSheet> createState() => _ThemesSheetState();
}

class _ThemesSheetState extends State<ThemesSheet> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredThemes = VisualThemes.getByCategory(_selectedCategory);

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
                        children: VisualThemes.categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: _FilterChip(
                                label: category,
                                isSelected: _selectedCategory == category,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Theme mixes section
                    const Text(
                      'Theme mixes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = 'Nature'),
                            child: _ThemeMixCard(
                              name: 'Nature',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF134e5e), Color(0xFF71b280)],
                              ),
                              isSelected: _selectedCategory == 'Nature',
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = 'Gradient'),
                            child: _ThemeMixCard(
                              name: 'Gradient',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                              ),
                              isSelected: _selectedCategory == 'Gradient',
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = 'Elegant'),
                            child: _ThemeMixCard(
                              name: 'Elegant',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0f0c29), Color(0xFF302b63)],
                              ),
                              isSelected: _selectedCategory == 'Elegant',
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = 'Plain'),
                            child: _ThemeMixCard(
                              name: 'Plain',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF5EDE4), Color(0xFFEDE5DC)],
                              ),
                              isSelected: _selectedCategory == 'Plain',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // For you section
                    Text(
                      _selectedCategory == 'All' ? 'For you' : _selectedCategory,
                      style: const TextStyle(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredThemes.length,
                          itemBuilder: (context, index) {
                            final theme = filteredThemes[index];
                            return ThemePreviewCard(
                              name: theme.name,
                              gradient: theme.gradient,
                              backgroundImage: theme.backgroundImage,
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
  final bool isSelected;

  const _ThemeMixCard({
    required this.name,
    required this.gradient,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppTheme.accent, width: 3)
            : null,
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: name == 'Plain' ? AppTheme.primaryText : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
