import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/models.dart';

class WidgetSettingsScreen extends StatefulWidget {
  const WidgetSettingsScreen({super.key});

  @override
  State<WidgetSettingsScreen> createState() => _WidgetSettingsScreenState();
}

class _WidgetSettingsScreenState extends State<WidgetSettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppState>().widgetSettings;
    _nameController = TextEditingController(text: settings.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showNameEditor(BuildContext context) {
    final appState = context.read<AppState>();
    _nameController.text = appState.widgetSettings.name;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Edit Widget Name'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter widget name',
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
              appState.updateWidgetName(_nameController.text.trim());
              Navigator.pop(dialogContext);
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

  void _showThemePicker(BuildContext context) {
    final appState = context.read<AppState>();
    final themes = VisualThemes.all;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              'Widget Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  final isSelected = appState.widgetSettings.themeId == theme.id;
                  return GestureDetector(
                    onTap: () {
                      appState.updateWidgetTheme(theme.id);
                      Navigator.pop(sheetContext);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: theme.gradient,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppTheme.accent, width: 3)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              theme.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 8,
                              top: 8,
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

  void _showTextSizePicker(BuildContext context) {
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
              'Text Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...WidgetTextSize.values.map((size) => ListTile(
              title: Text(
                size.displayName,
                style: TextStyle(fontSize: size.fontSize),
              ),
              trailing: appState.widgetSettings.textSize == size
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.updateWidgetTextSize(size);
                Navigator.pop(sheetContext);
              },
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showRefreshFrequencyPicker(BuildContext context) {
    final appState = context.read<AppState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              'Refresh Frequency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: WidgetRefreshFrequency.values.map((freq) => ListTile(
                  title: Text(freq.displayName),
                  trailing: appState.widgetSettings.refreshFrequency == freq
                      ? const Icon(Icons.check_circle, color: AppTheme.accent)
                      : null,
                  onTap: () {
                    appState.updateWidgetRefreshFrequency(freq);
                    Navigator.pop(sheetContext);
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContentTypePicker(BuildContext context) {
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
              'Type of Quotes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...WidgetContentType.values.map((type) => ListTile(
              title: Text(type.displayName),
              trailing: appState.widgetSettings.contentType == type
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.updateWidgetContentType(type);
                Navigator.pop(sheetContext);
              },
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showButtonStylePicker(BuildContext context) {
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
              'Visible Buttons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...WidgetButtonStyle.values.map((style) => ListTile(
              title: Text(style.displayName),
              trailing: appState.widgetSettings.buttonStyle == style
                  ? const Icon(Icons.check_circle, color: AppTheme.accent)
                  : null,
              onTap: () {
                appState.updateWidgetButtonStyle(style);
                Navigator.pop(sheetContext);
              },
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
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
                    'Widget',
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
                'Customize your home screen widget',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),

            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  final settings = appState.widgetSettings;
                  final theme = VisualThemes.getById(settings.themeId);

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Widget Preview
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: theme.gradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'For I know the plans I have for you...',
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: settings.textSize.fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jeremiah 29:11',
                              style: TextStyle(
                                color: theme.textColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Settings Section
                      _SettingsSection(
                        title: 'APPEARANCE',
                        items: [
                          _SettingsItem(
                            icon: Icons.edit_outlined,
                            title: 'Edit name',
                            subtitle: settings.name,
                            onTap: () => _showNameEditor(context),
                          ),
                          _SettingsItem(
                            icon: Icons.palette_outlined,
                            title: 'Change theme',
                            subtitle: theme.name,
                            onTap: () => _showThemePicker(context),
                          ),
                          _SettingsItem(
                            icon: Icons.text_fields,
                            title: 'Text size',
                            subtitle: settings.textSize.displayName,
                            onTap: () => _showTextSizePicker(context),
                          ),
                        ],
                      ),

                      _SettingsSection(
                        title: 'CONTENT',
                        items: [
                          _SettingsItem(
                            icon: Icons.refresh,
                            title: 'Refresh frequency',
                            subtitle: settings.refreshFrequency.displayName,
                            onTap: () => _showRefreshFrequencyPicker(context),
                          ),
                          _SettingsItem(
                            icon: Icons.format_quote,
                            title: 'Type of quotes',
                            subtitle: settings.contentType.displayName,
                            onTap: () => _showContentTypePicker(context),
                          ),
                        ],
                      ),

                      _SettingsSection(
                        title: 'INTERACTION',
                        items: [
                          _SettingsItem(
                            icon: Icons.touch_app_outlined,
                            title: 'Visible buttons',
                            subtitle: settings.buttonStyle.displayName,
                            onTap: () => _showButtonStylePicker(context),
                          ),
                        ],
                      ),

                      // Info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add the widget to your home screen from your device\'s widget gallery.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
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
