import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    'Last Updated',
                    'February 2, 2026',
                  ),
                  _buildSection(
                    'Introduction',
                    'Welcome to Bible Widgets ("we," "our," or "us"). We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
                  ),
                  _buildSection(
                    'Information We Collect',
                    '''We may collect the following types of information:

Personal Information:
- Name (optional, for personalization)
- Gender (optional, for personalized content)
- Age range (optional, for content recommendations)

Usage Data:
- App usage statistics
- Content preferences and favorites
- Reading history within the app

Device Information:
- Device type and model
- Operating system version
- Unique device identifiers''',
                  ),
                  _buildSection(
                    'How We Use Your Information',
                    '''We use the collected information to:

- Personalize your app experience
- Display customized Bible verses and inspirational content
- Remember your preferences and settings
- Improve our app and services
- Send notifications (with your permission)
- Analyze app performance and usage patterns''',
                  ),
                  _buildSection(
                    'Data Storage',
                    'Your personal data is stored locally on your device. We do not transfer your personal information to external servers unless explicitly required for specific features (such as cloud backup, if available).',
                  ),
                  _buildSection(
                    'Third-Party Services',
                    '''Our app may use third-party services that collect information:

- Google Play Services (Android)
- Apple App Store Services (iOS)
- Analytics services (anonymized data only)

These services have their own privacy policies governing the use of your information.''',
                  ),
                  _buildSection(
                    'Data Security',
                    'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                  ),
                  _buildSection(
                    'Your Rights',
                    '''You have the right to:

- Access your personal data
- Correct inaccurate data
- Delete your data (by clearing app data or uninstalling)
- Opt-out of personalization features
- Disable notifications''',
                  ),
                  _buildSection(
                    'Children\'s Privacy',
                    'Our app is suitable for users of all ages. We do not knowingly collect personal information from children under 13 without parental consent.',
                  ),
                  _buildSection(
                    'Changes to This Policy',
                    'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy within the app and updating the "Last Updated" date.',
                  ),
                  _buildSection(
                    'Contact Us',
                    '''If you have questions about this Privacy Policy, please contact us at:

Email: support@biblewidgets.app

We will respond to your inquiry within a reasonable timeframe.''',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
