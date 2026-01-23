import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

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
                    GestureDetector(
                      onTap: () => _showSettings(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.cardBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.settings_outlined, size: 20),
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
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Unlock all banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Unlock all',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Access all categories, quotes, themes, and remove ads!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.primaryText.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.menu_book_outlined,
                            size: 48,
                            color: AppTheme.primaryText.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Streak widget
                    Consumer<AppState>(
                      builder: (context, appState, _) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Your streak',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.ios_share, size: 20),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_horiz, size: 20),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              StreakWidget(
                                streakCount: appState.user.streakCount,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Customize section
                    const Text(
                      'Customize the app',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Customize grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        _CustomizeCard(
                          title: 'Topics you follow',
                          icon: Icons.grid_view_rounded,
                          onTap: () {},
                        ),
                        _CustomizeCard(
                          title: 'App icon',
                          icon: Icons.apps_rounded,
                          onTap: () {},
                        ),
                        _CustomizeCard(
                          title: 'Home Screen widgets',
                          icon: Icons.widgets_outlined,
                          onTap: () => _showWidgetGuide(context, 'Home Screen'),
                        ),
                        _CustomizeCard(
                          title: 'Lock Screen widgets',
                          icon: Icons.lock_outline,
                          onTap: () => _showWidgetGuide(context, 'Lock Screen'),
                        ),
                        _CustomizeCard(
                          title: 'Reminders',
                          icon: Icons.notifications_outlined,
                          onTap: () {},
                        ),
                        _CustomizeCard(
                          title: 'Watch',
                          icon: Icons.watch_outlined,
                          onTap: () {},
                        ),
                      ],
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

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SettingsSheet(),
    );
  }

  void _showWidgetGuide(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WidgetGuideSheet(type: type),
    );
  }
}

class _CustomizeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CustomizeCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              icon,
              size: 32,
              color: AppTheme.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

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
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.chevron_left, size: 28),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SettingsSection(
                      title: 'PREMIUM',
                      items: [
                        _SettingsItem(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Manage subscription',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'MAKE IT YOURS',
                      items: [
                        _SettingsItem(
                          icon: Icons.person_outline,
                          title: 'Gender',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.volume_off_outlined,
                          title: 'Muted content',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.language,
                          title: 'Language',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.badge_outlined,
                          title: 'Name',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.volume_up_outlined,
                          title: 'Sound',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'ACCOUNT',
                      items: [
                        _SettingsItem(
                          icon: Icons.login,
                          title: 'Sign in',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'SUPPORT US',
                      items: [
                        _SettingsItem(
                          icon: Icons.ios_share,
                          title: 'Share Bible Widgets',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.apps,
                          title: 'More by Monkey Taps',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.star_outline,
                          title: 'Leave us a review',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.card_giftcard,
                          title: 'Give feedback',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'HELP',
                      items: [
                        _SettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'FOLLOW US',
                      items: [
                        _SettingsItem(
                          icon: Icons.camera_alt_outlined,
                          title: 'Instagram',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.music_note,
                          title: 'TikTok',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.facebook,
                          title: 'Facebook',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'OTHER',
                      items: [
                        _SettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms and Conditions',
                          onTap: () {},
                        ),
                      ],
                    ),
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  item,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: AppTheme.secondaryText.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppTheme.primaryText),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetGuideSheet extends StatelessWidget {
  final String type;

  const _WidgetGuideSheet({required this.type});

  @override
  Widget build(BuildContext context) {
    final isLockScreen = type == 'Lock Screen';
    
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
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.chevron_left, size: 28),
                    ),
                    Expanded(
                      child: Text(
                        '$type widgets',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Phone mockup
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Notch
                          Container(
                            width: 80,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryText.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (isLockScreen) ...[
                            Text(
                              'Monday 20 June 06',
                              style: TextStyle(
                                color: AppTheme.secondaryText.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '9:41',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.secondaryText.withOpacity(0.5),
                              ),
                            ),
                          ] else ...[
                            // Widget preview
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.accent,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Today, I protect the peace that God has planted in me.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Instructions
                    Text(
                      'Add a widget to your phone\'s $type',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    if (isLockScreen) ...[
                      _InstructionItem(
                        number: '1',
                        text: 'Long-press your Lock Screen, then tap "Customize"',
                      ),
                      _InstructionItem(
                        number: '2',
                        text: 'Tap the widget area and add it',
                      ),
                      _InstructionItem(
                        number: '3',
                        text: 'Tap the widget to customize content, font, and refresh rate',
                      ),
                    ] else ...[
                      _InstructionItem(
                        number: '1',
                        text: 'On your phone\'s Home Screen, touch and hold an empty area until the apps jiggle',
                      ),
                      _InstructionItem(
                        number: '2',
                        text: 'Tap "Edit" in the upper left corner, then tap "Add Widget"',
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Install widget'),
                    ),
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

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
