import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common_widgets.dart';
import '../data/content_data.dart';
import '../models/models.dart';
import '../services/notification_service.dart';
import 'app_icon_screen.dart';

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
                          onTap: () => _showTopicsFollowed(context),
                        ),
                        _CustomizeCard(
                          title: 'App icon',
                          icon: Icons.apps_rounded,
                          onTap: () => _showAppIconPicker(context),
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
                          onTap: () => _showReminderSettings(context),
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

  void _showTopicsFollowed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TopicsFollowedSheet(),
    );
  }

  void _showAppIconPicker(BuildContext context) {
    Navigator.pop(context); // Close profile sheet first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AppIconScreen(),
      ),
    );
  }

  void _showReminderSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ReminderSettingsSheet(),
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

  void _showGenderPicker(BuildContext context) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Gender',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.male, color: Colors.blue),
              title: const Text('Male'),
              trailing: appState.user.gender == 'male'
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.setGender('male');
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              leading: const Icon(Icons.female, color: Colors.pink),
              title: const Text('Female'),
              trailing: appState.user.gender == 'female'
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.setGender('female');
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.grey[600]),
              title: const Text('Prefer not to say'),
              trailing: appState.user.gender == null || appState.user.gender!.isEmpty
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.setGender('');
                Navigator.pop(sheetContext);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showNameEditor(BuildContext context) {
    final appState = context.read<AppState>();
    final controller = TextEditingController(text: appState.user.name);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.setUserName(controller.text.trim());
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Name updated'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Save',
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

  void _shareApp() {
    Share.share(
      'Check out Bible Widgets - Daily verses and inspiration for your faith journey!\n\nhttps://play.google.com/store/apps/details?id=com.oneapp.biblewidget',
      subject: 'Bible Widgets',
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
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
                child: Consumer<AppState>(
                  builder: (context, appState, _) {
                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _SettingsSection(
                          title: 'PERSONALIZE',
                          items: [
                            _SettingsItem(
                              icon: Icons.person_outline,
                              title: 'Gender',
                              subtitle: appState.user.gender?.isNotEmpty == true
                                  ? appState.user.gender!.substring(0, 1).toUpperCase() + appState.user.gender!.substring(1)
                                  : 'Not set',
                              onTap: () => _showGenderPicker(context),
                            ),
                            _SettingsItem(
                              icon: Icons.badge_outlined,
                              title: 'Name',
                              subtitle: appState.user.name?.isNotEmpty == true ? appState.user.name! : 'Not set',
                              onTap: () => _showNameEditor(context),
                            ),
                          ],
                        ),
                        _SettingsSection(
                          title: 'SUPPORT US',
                          items: [
                            _SettingsItem(
                              icon: Icons.ios_share,
                              title: 'Share Bible Widgets',
                              onTap: _shareApp,
                            ),
                          ],
                        ),
                        _SettingsSection(
                          title: 'LEGAL',
                          items: [
                            _SettingsItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              onTap: () => _openUrl('https://example.com/privacy'),
                            ),
                            _SettingsItem(
                              icon: Icons.description_outlined,
                              title: 'Terms and Conditions',
                              onTap: () => _openUrl('https://example.com/terms'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppTheme.primaryText),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.secondaryText.withOpacity(0.7),
                      ),
                    ),
                ],
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

class _TopicsFollowedSheet extends StatelessWidget {
  const _TopicsFollowedSheet();

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
                        'Topics you follow',
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
                child: Consumer<AppState>(
                  builder: (context, appState, _) {
                    final topics = ContentData.topics;
                    final selectedTopics = appState.user.selectedTopics;

                    // Group topics by category
                    final Map<String, List<Topic>> topicsByCategory = {};
                    for (final topic in topics) {
                      topicsByCategory.putIfAbsent(topic.category, () => []);
                      topicsByCategory[topic.category]!.add(topic);
                    }

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        // General section (always shown)
                        _TopicFollowItem(
                          icon: '📋',
                          title: 'General',
                          subtitle: 'All content',
                          isFollowed: selectedTopics.isEmpty,
                          onTap: () => appState.setSelectedTopics([]),
                        ),
                        const SizedBox(height: 8),
                        _TopicFollowItem(
                          icon: '❤️',
                          title: 'Favorites',
                          subtitle: '${appState.favoritesCount} saved',
                          isFollowed: false,
                          showFollowButton: false,
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        _TopicFollowItem(
                          icon: '✏️',
                          title: 'My own quotes',
                          subtitle: '${appState.customQuotes.length} quotes',
                          isFollowed: false,
                          showFollowButton: false,
                          onTap: () {},
                        ),

                        const SizedBox(height: 24),

                        // Topics by category
                        ...topicsByCategory.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map((topic) {
                                final isFollowed = selectedTopics.contains(topic.id);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _TopicFollowItem(
                                    icon: topic.icon,
                                    title: topic.name,
                                    subtitle: isFollowed ? 'Following' : '',
                                    isFollowed: isFollowed,
                                    onTap: () => appState.toggleTopic(topic.id),
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopicFollowItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isFollowed;
  final bool showFollowButton;
  final VoidCallback onTap;

  const _TopicFollowItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isFollowed,
    this.showFollowButton = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondaryText.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.secondaryText.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
            if (showFollowButton)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isFollowed
                      ? AppTheme.accent
                      : AppTheme.secondaryText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFollowed ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isFollowed ? Colors.white : AppTheme.primaryText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppIconPickerSheet extends StatelessWidget {
  const _AppIconPickerSheet();

  @override
  Widget build(BuildContext context) {
    // Available app icons
    final appIcons = [
      ('default', 'Default', AppTheme.accent),
      ('dark', 'Dark', const Color(0xFF1A1A1A)),
      ('light', 'Light', const Color(0xFFF5EDE4)),
      ('gold', 'Gold', const Color(0xFFD4AF37)),
      ('rose', 'Rose', const Color(0xFFE8B4B8)),
      ('ocean', 'Ocean', const Color(0xFF4FACFE)),
      ('forest', 'Forest', const Color(0xFF71B280)),
      ('sunset', 'Sunset', const Color(0xFFFF7E5F)),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                        'App Icon',
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

              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Choose your favorite app icon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: appIcons.length,
                  itemBuilder: (context, index) {
                    final icon = appIcons[index];
                    final isSelected = index == 0; // Default is selected

                    return GestureDetector(
                      onTap: () {
                        // Show coming soon message for non-default icons
                        if (index != 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('App icon changing coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: icon.$3,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(color: AppTheme.accent, width: 3)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: icon.$3.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: icon.$1 == 'light'
                                    ? AppTheme.primaryText
                                    : Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            icon.$2,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.primaryText
                                  : AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppTheme.secondaryText.withOpacity(0.7),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'The icon change may take a few seconds to appear on your home screen.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.secondaryText.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReminderSettingsSheet extends StatefulWidget {
  const _ReminderSettingsSheet();

  @override
  State<_ReminderSettingsSheet> createState() => _ReminderSettingsSheetState();
}

class _ReminderSettingsSheetState extends State<_ReminderSettingsSheet> {
  bool _isEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await NotificationService.isReminderEnabled();
    final time = await NotificationService.getReminderTime();
    if (mounted) {
      setState(() {
        _isEnabled = enabled;
        if (time != null) _reminderTime = time;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() => _isEnabled = value);

    if (value) {
      final granted = await NotificationService.requestPermissions();
      if (granted) {
        await NotificationService.scheduleDailyReminder(
          hour: _reminderTime.hour,
          minute: _reminderTime.minute,
        );
      } else {
        setState(() => _isEnabled = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied'),
            ),
          );
        }
      }
    } else {
      await NotificationService.cancelAllReminders();
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.accent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => _reminderTime = time);
      if (_isEnabled) {
        await NotificationService.scheduleDailyReminder(
          hour: time.hour,
          minute: time.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeString =
        '${_reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod}:${_reminderTime.minute.toString().padLeft(2, '0')} ${_reminderTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
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
                        'Reminders',
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

              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.accent),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Enable/Disable toggle
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: AppTheme.accent,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Daily reminder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isEnabled,
                              onChanged: _toggleReminder,
                              activeColor: AppTheme.accent,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Time picker
                      GestureDetector(
                        onTap: _isEnabled ? _pickTime : null,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: _isEnabled
                                    ? AppTheme.accent
                                    : AppTheme.secondaryText.withOpacity(0.5),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Reminder time',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isEnabled
                                        ? AppTheme.primaryText
                                        : AppTheme.secondaryText.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Text(
                                timeString,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _isEnabled
                                      ? AppTheme.accent
                                      : AppTheme.secondaryText.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: _isEnabled
                                    ? AppTheme.secondaryText
                                    : AppTheme.secondaryText.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info text
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppTheme.secondaryText.withOpacity(0.7),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You\'ll receive a daily notification with an inspiring verse to help you start your day with faith.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.secondaryText.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Test notification button
                      if (_isEnabled)
                        GestureDetector(
                          onTap: () async {
                            await NotificationService.showTestNotification();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Test notification sent!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.accent.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send_outlined,
                                  color: AppTheme.accent,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Send test notification',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accent,
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
        );
      },
    );
  }
}
