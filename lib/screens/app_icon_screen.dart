import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AppIconScreen extends StatefulWidget {
  const AppIconScreen({super.key});

  @override
  State<AppIconScreen> createState() => _AppIconScreenState();
}

class _AppIconScreenState extends State<AppIconScreen> {
  String _selectedIcon = 'default';
  bool _isActivating = false;

  static const platform = MethodChannel('com.biblewidgets/app_icon');

  final List<AppIconOption> _icons = [
    AppIconOption(
      id: 'default',
      name: 'Default',
      color: const Color(0xFFD4A574),
      description: 'Warm golden theme',
    ),
    AppIconOption(
      id: 'dark',
      name: 'Dark',
      color: const Color(0xFF1A1A1A),
      description: 'Sleek dark mode',
    ),
    AppIconOption(
      id: 'light',
      name: 'Light',
      color: const Color(0xFFF5EDE4),
      description: 'Clean and bright',
    ),
    AppIconOption(
      id: 'gold',
      name: 'Gold',
      color: const Color(0xFFD4AF37),
      description: 'Elegant gold accent',
    ),
    AppIconOption(
      id: 'rose',
      name: 'Rose',
      color: const Color(0xFFE8B4B8),
      description: 'Soft pink tones',
    ),
    AppIconOption(
      id: 'ocean',
      name: 'Ocean',
      color: const Color(0xFF4FACFE),
      description: 'Calm blue waters',
    ),
    AppIconOption(
      id: 'forest',
      name: 'Forest',
      color: const Color(0xFF71B280),
      description: 'Natural green',
    ),
    AppIconOption(
      id: 'sunset',
      name: 'Sunset',
      color: const Color(0xFFFF7E5F),
      description: 'Warm orange glow',
    ),
  ];

  Future<void> _activateIcon() async {
    setState(() => _isActivating = true);

    try {
      await platform.invokeMethod('setAppIcon', {'iconName': _selectedIcon});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App icon updated! The app will restart.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change icon: ${e.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isActivating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIconData = _icons.firstWhere((i) => i.id == _selectedIcon);

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
                    'App icon',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Change your app icon',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Step 1
                  _StepCard(
                    stepNumber: 1,
                    title: 'Step 1',
                    description: '1. Tap the "Activate" button below.',
                  ),
                  const SizedBox(height: 12),

                  // Step 2 - with icon preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Step 2',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                '2. This will automatically shut down the app.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Icon preview
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: selectedIconData.color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: selectedIconData.color.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Step 3
                  _StepCard(
                    stepNumber: 3,
                    title: 'Step 3',
                    description: '3. Reopen the app, go back to "Settings" and tap "App icon."',
                  ),
                  const SizedBox(height: 12),

                  // Step 4
                  _StepCard(
                    stepNumber: 4,
                    title: 'Step 4',
                    description: '4. Tap to select your new app icon!',
                  ),
                  const SizedBox(height: 24),

                  // Icon selection grid
                  const Text(
                    'Choose your icon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _icons.length,
                    itemBuilder: (context, index) {
                      final icon = _icons[index];
                      final isSelected = icon.id == _selectedIcon;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedIcon = icon.id);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: icon.color,
                                borderRadius: BorderRadius.circular(14),
                                border: isSelected
                                    ? Border.all(
                                        color: AppTheme.accent,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: icon.color.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: icon.color.computeLuminance() > 0.5
                                      ? Colors.black54
                                      : Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              icon.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80), // Space for button
                ],
              ),
            ),

            // Activate button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isActivating ? null : _activateIcon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryText,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isActivating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Activate',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class AppIconOption {
  final String id;
  final String name;
  final Color color;
  final String description;

  const AppIconOption({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
  });
}
