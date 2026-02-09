import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import '../theme/app_theme.dart';

class AppIconScreen extends StatefulWidget {
  const AppIconScreen({super.key});

  @override
  State<AppIconScreen> createState() => _AppIconScreenState();
}

class _AppIconScreenState extends State<AppIconScreen> {
  String _currentIcon = 'default';
  bool _isLoading = true;
  bool _isChanging = false;
  bool _supportsAlternateIcons = false;

  // Icon options with their visual representations
  final List<AppIconOption> _icons = [
    AppIconOption(
      id: 'default',
      name: 'Default',
      colors: [Color(0xFFF5EDE4), Color(0xFFD4A574)],
      description: 'Original design',
    ),
    AppIconOption(
      id: 'navy_stars',
      name: 'Navy Stars',
      colors: [Color(0xFF1A2744), Color(0xFFD4A574)],
      description: 'Navy with gold cross',
    ),
    AppIconOption(
      id: 'cream_olive',
      name: 'Cream',
      colors: [Color(0xFFF5F0E8), Color(0xFF8B7355)],
      description: 'Cream with olive branch',
    ),
    AppIconOption(
      id: 'gold_luxe',
      name: 'Gold Luxe',
      colors: [Color(0xFFD4A574), Color(0xFF8B6914)],
      description: 'Elegant gold',
    ),
    AppIconOption(
      id: 'white_wave',
      name: 'White Wave',
      colors: [Color(0xFFFFFFFF), Color(0xFFD4A574)],
      description: 'White with waves',
    ),
    AppIconOption(
      id: 'teal_pink',
      name: 'Teal Pink',
      colors: [Color(0xFF5BBFBA), Color(0xFFFFB6C1)],
      description: 'Teal and pink gradient',
    ),
    AppIconOption(
      id: 'ocean_clouds',
      name: 'Ocean',
      colors: [Color(0xFF4A90B8), Color(0xFFFFFFFF)],
      description: 'Ocean blue with clouds',
    ),
    AppIconOption(
      id: 'night_gold',
      name: 'Night Gold',
      colors: [Color(0xFF1A2744), Color(0xFFE8C47C)],
      description: 'Night sky with gold',
    ),
    AppIconOption(
      id: 'sunset_coral',
      name: 'Sunset',
      colors: [Color(0xFFFF8C69), Color(0xFFFFFFFF)],
      description: 'Sunset coral',
    ),
    AppIconOption(
      id: 'royal_purple',
      name: 'Royal Purple',
      colors: [Color(0xFF6B4C8A), Color(0xFFD4A574)],
      description: 'Royal purple',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  Future<void> _loadCurrentIcon() async {
    if (!Platform.isIOS) {
      setState(() {
        _isLoading = false;
        _supportsAlternateIcons = false;
      });
      return;
    }

    try {
      final supports = await FlutterDynamicIcon.supportsAlternateIcons;
      String? currentIcon;
      try {
        currentIcon = await FlutterDynamicIcon.getAlternateIconName();
      } catch (e) {
        currentIcon = null;
      }

      if (mounted) {
        setState(() {
          _supportsAlternateIcons = supports;
          _currentIcon = currentIcon ?? 'default';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading icon state: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _supportsAlternateIcons = false;
        });
      }
    }
  }

  Future<void> _changeIcon(String iconId) async {
    if (iconId == _currentIcon || _isChanging) return;

    setState(() => _isChanging = true);

    try {
      if (iconId == 'default') {
        await FlutterDynamicIcon.setAlternateIconName(null);
      } else {
        // Use Asset Catalog name format: "AppIcon-{name}"
        await FlutterDynamicIcon.setAlternateIconName('AppIcon-$iconId');
      }

      if (mounted) {
        setState(() {
          _currentIcon = iconId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('App icon changed to ${_icons.firstWhere((i) => i.id == iconId).name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error changing icon: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change icon: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChanging = false);
      }
    }
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
                    'App Icon',
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
                'Choose your app icon style',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (!Platform.isIOS)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, size: 48, color: AppTheme.secondaryText),
                        const SizedBox(height: 16),
                        Text(
                          'Alternate app icons are only available on iOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (!_supportsAlternateIcons)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber, size: 48, color: AppTheme.secondaryText),
                        const SizedBox(height: 16),
                        Text(
                          'Your device does not support alternate app icons',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final icon = _icons[index];
                    final isSelected = icon.id == _currentIcon;

                    return GestureDetector(
                      onTap: _isChanging ? null : () => _changeIcon(icon.id),
                      child: Opacity(
                        opacity: _isChanging && !isSelected ? 0.5 : 1.0,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                // Icon preview
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: icon.colors.first,
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
                                              color: AppTheme.accent.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: _buildCrossIcon(icon.colors.last),
                                  ),
                                ),
                                // Checkmark for current icon
                                if (isSelected)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.accent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
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
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrossIcon(Color color) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: CrossPainter(color: color),
    );
  }
}

class CrossPainter extends CustomPainter {
  final Color color;

  CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final thickness = size.width / 5;
    final armLength = size.height / 2.5;

    // Vertical bar
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: thickness,
        height: armLength * 2,
      ),
      paint,
    );

    // Horizontal bar (higher up)
    final barY = cy - armLength / 3;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, barY),
        width: armLength,
        height: thickness,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppIconOption {
  final String id;
  final String name;
  final List<Color> colors;
  final String description;

  const AppIconOption({
    required this.id,
    required this.name,
    required this.colors,
    required this.description,
  });
}
