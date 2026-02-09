import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import '../theme/app_theme.dart';

class AppIconScreen extends StatefulWidget {
  const AppIconScreen({super.key});

  @override
  State<AppIconScreen> createState() => _AppIconScreenState();
}

class _AppIconScreenState extends State<AppIconScreen> {
  static const platform = MethodChannel('com.biblewidgets/app_icon');

  String _currentIcon = 'default';
  bool _isLoading = true;
  bool _isChanging = false;
  bool _supportsAlternateIcons = false;

  // Icon options with their asset paths
  final List<AppIconOption> _icons = [
    AppIconOption(
      id: 'default',
      name: 'Default',
      assetPath: 'assets/icons/icon_default.png',
    ),
    AppIconOption(
      id: 'navy_stars',
      name: 'Navy Stars',
      assetPath: 'assets/icons/icon_navy_stars.png',
    ),
    AppIconOption(
      id: 'cream_olive',
      name: 'Cream',
      assetPath: 'assets/icons/icon_cream_olive.png',
    ),
    AppIconOption(
      id: 'gold_luxe',
      name: 'Gold Luxe',
      assetPath: 'assets/icons/icon_gold_luxe.png',
    ),
    AppIconOption(
      id: 'white_wave',
      name: 'White Wave',
      assetPath: 'assets/icons/icon_white_wave.png',
    ),
    AppIconOption(
      id: 'teal_pink',
      name: 'Teal Pink',
      assetPath: 'assets/icons/icon_teal_pink.png',
    ),
    AppIconOption(
      id: 'ocean_clouds',
      name: 'Ocean',
      assetPath: 'assets/icons/icon_ocean_clouds.png',
    ),
    AppIconOption(
      id: 'night_gold',
      name: 'Night Gold',
      assetPath: 'assets/icons/icon_night_gold.png',
    ),
    AppIconOption(
      id: 'sunset_coral',
      name: 'Sunset',
      assetPath: 'assets/icons/icon_sunset_coral.png',
    ),
    AppIconOption(
      id: 'royal_purple',
      name: 'Royal Purple',
      assetPath: 'assets/icons/icon_royal_purple.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  Future<void> _loadCurrentIcon() async {
    if (Platform.isIOS) {
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
            // Parse icon name from "AppIcon-xxx" format
            if (currentIcon != null && currentIcon.startsWith('AppIcon-')) {
              _currentIcon = currentIcon.substring(8);
            } else {
              _currentIcon = 'default';
            }
            _isLoading = false;
          });
        }
      } catch (e) {
        if (kDebugMode) print('Error loading icon state: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _supportsAlternateIcons = false;
          });
        }
      }
    } else if (Platform.isAndroid) {
      try {
        final currentIcon = await platform.invokeMethod('getCurrentIcon');
        if (mounted) {
          setState(() {
            _supportsAlternateIcons = true;
            _currentIcon = currentIcon ?? 'default';
            _isLoading = false;
          });
        }
      } catch (e) {
        if (kDebugMode) print('Error loading Android icon state: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _supportsAlternateIcons = false;
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
        _supportsAlternateIcons = false;
      });
    }
  }

  Future<void> _changeIcon(String iconId) async {
    if (iconId == _currentIcon || _isChanging) return;

    setState(() => _isChanging = true);

    try {
      if (Platform.isIOS) {
        if (iconId == 'default') {
          await FlutterDynamicIcon.setAlternateIconName(null);
        } else {
          // Use Asset Catalog name format: "AppIcon-{name}"
          await FlutterDynamicIcon.setAlternateIconName('AppIcon-$iconId');
        }
      } else if (Platform.isAndroid) {
        await platform.invokeMethod('setAppIcon', {'iconName': iconId});
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
      if (kDebugMode) print('Error changing icon: $e');
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
                                // Icon preview using actual image
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(isSelected ? 11 : 14),
                                    child: Image.asset(
                                      icon.assetPath,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
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
}

class AppIconOption {
  final String id;
  final String name;
  final String assetPath;

  const AppIconOption({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}
