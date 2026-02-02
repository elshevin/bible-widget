import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import 'app_icon_screen.dart';
import 'widget_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  return ListView(
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
                          _SettingsItem(
                            icon: Icons.apps,
                            title: 'App Icon',
                            subtitle: 'Customize your app icon',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AppIconScreen(),
                                ),
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.widgets_outlined,
                            title: 'Widget',
                            subtitle: 'Customize your home screen widget',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WidgetSettingsScreen(),
                                ),
                              );
                            },
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.description_outlined,
                            title: 'Terms and Conditions',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TermsScreen(),
                                ),
                              );
                            },
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
      ),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
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
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryText),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 13,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.secondaryText,
      ),
      onTap: onTap,
    );
  }
}
