import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                    'Terms and Conditions',
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
                    'Agreement to Terms',
                    'By downloading, installing, or using Bible Widgets ("the App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.',
                  ),
                  _buildSection(
                    'Description of Service',
                    'Bible Widgets is a mobile application that provides daily Bible verses, inspirational quotes, prayers, and affirmations. The App includes home screen widgets and personalization features to enhance your spiritual journey.',
                  ),
                  _buildSection(
                    'User Account',
                    '''You may use the App without creating an account. However, certain features may require you to provide personal information for personalization purposes.

You are responsible for:
- Maintaining the confidentiality of your device
- All activities that occur through the App on your device
- Ensuring your use complies with applicable laws''',
                  ),
                  _buildSection(
                    'Acceptable Use',
                    '''You agree NOT to:

- Use the App for any unlawful purpose
- Attempt to gain unauthorized access to the App's systems
- Interfere with or disrupt the App's functionality
- Reverse engineer, decompile, or disassemble the App
- Remove any copyright or proprietary notices
- Use the App to distribute malware or harmful content
- Resell or redistribute the App's content without permission''',
                  ),
                  _buildSection(
                    'Intellectual Property',
                    '''All content in the App, including but not limited to:

- App design and interface
- Graphics, images, and icons
- Original quotes and content
- Software code and functionality

is owned by Bible Widgets or its licensors and is protected by copyright, trademark, and other intellectual property laws.

Bible verses are sourced from public domain translations unless otherwise noted.''',
                  ),
                  _buildSection(
                    'User Content',
                    'You retain ownership of any content you create within the App (such as custom quotes or collections). By creating content, you grant us a non-exclusive license to store and display that content within the App on your device.',
                  ),
                  _buildSection(
                    'Premium Features',
                    '''Some features may require a premium subscription or one-time purchase. By making a purchase:

- You agree to pay all fees associated with your purchase
- Subscriptions auto-renew unless cancelled
- Refunds are subject to the app store's refund policy
- We reserve the right to modify pricing with notice''',
                  ),
                  _buildSection(
                    'Disclaimer of Warranties',
                    '''THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND.

We do not warrant that:
- The App will be uninterrupted or error-free
- Defects will be corrected
- The App is free of viruses or harmful components
- The content is accurate or reliable''',
                  ),
                  _buildSection(
                    'Limitation of Liability',
                    'TO THE MAXIMUM EXTENT PERMITTED BY LAW, BIBLE WIDGETS SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING FROM YOUR USE OF THE APP.',
                  ),
                  _buildSection(
                    'Indemnification',
                    'You agree to indemnify and hold harmless Bible Widgets and its affiliates from any claims, damages, or expenses arising from your use of the App or violation of these Terms.',
                  ),
                  _buildSection(
                    'Modifications to Terms',
                    'We reserve the right to modify these Terms at any time. Changes will be effective immediately upon posting within the App. Your continued use of the App constitutes acceptance of the modified Terms.',
                  ),
                  _buildSection(
                    'Termination',
                    'We may terminate or suspend your access to the App at any time, without prior notice, for conduct that we believe violates these Terms or is harmful to other users or the App.',
                  ),
                  _buildSection(
                    'Governing Law',
                    'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which Bible Widgets operates, without regard to conflict of law principles.',
                  ),
                  _buildSection(
                    'Contact Information',
                    '''For questions about these Terms and Conditions, please contact us at:

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
