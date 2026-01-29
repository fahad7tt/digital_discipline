import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:share_plus/share_plus.dart';
import 'legal_document_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Account & App'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('App Version'),
            subtitle: const Text('1.10.0'),
          ),
          ListTile(
            leading: const Icon(Icons.rate_review_outlined),
            title: const Text('Rate & Feedback'),
            subtitle: const Text('Help us improve on Play Store'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              _openFeedback();
            },
          ),
          ListTile(
            leading: const Icon(Icons.mobile_screen_share_outlined),
            title: const Text('Share App'),
            subtitle: const Text('Share to your friends and family'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              _shareApp();
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Legal'),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(
                    title: 'Terms & Conditions',
                    sections: [
                      LegalSection(
                        title: 'Acceptance of Terms',
                        content:
                            'By downloading or using the Intent app, you agree to these terms and conditions. If you do not agree, please do not use the application.',
                      ),
                      LegalSection(
                        title: 'Purpose of App',
                        content:
                            'Intent is a tool designed to help you monitor your digital habits and improve your digital discipline. It is provided on an "as-is" and "as-available" basis.',
                      ),
                      LegalSection(
                        title: 'User Responsibility',
                        content:
                            'You are responsible for the data you input and how you use the insights provided by the app. You must grant the necessary permissions (Usage Access) for the app to function as intended.',
                      ),
                      LegalSection(
                        title: 'Intellectual Property',
                        content:
                            'The "Intent" brand, app design, and original content (insights, UI) are the intellectual property of the app creator.',
                      ),
                      LegalSection(
                        title: 'Limitation of Liability',
                        content:
                            'The app creator shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the app. We do not guarantee specific outcomes regarding your digital habits.',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(
                    title: 'Privacy Policy',
                    sections: [
                      LegalSection(
                        title: 'Introduction',
                        content:
                            'Welcome to Intent - Digital Discipline. We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we handle your data when you use our mobile application. Effective Date: December 26, 2025.',
                      ),
                      LegalSection(
                        title: 'Data Collection and Usage',
                        content:
                            'The App is designed to operate locally on your device.\n\n• App Usage Statistics: To provide you with digital habit insights, we use Android\'s UsageStatsManager. This is processed locally and never sent to our servers.\n• User Reflections: Daily reflections and intentions are stored locally.',
                      ),
                      LegalSection(
                        title: 'Data Storage and Security',
                        content:
                            'All your data is stored locally on your device using Hive. We do not maintain any cloud-based servers, and your data is never uploaded to any external storage managed by us.',
                      ),
                      LegalSection(
                        title: 'Data Sharing and Permissions',
                        content:
                            '• No Data Sharing: We do not sell or trade your information with third parties.\n• Permissions: We require Usage Access for stats and Notifications for reminders.',
                      ),
                      LegalSection(
                        title: 'Data Deletion',
                        content:
                            'You have full control. You can delete all App data by clearing the App\'s storage in device settings or by uninstalling the App.',
                      ),
                      LegalSection(
                        title: 'Changes to This Policy',
                        content:
                            'We may update this policy from time to time. We will notify you of any material changes.',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Support'),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text('Email Support'),
            subtitle: const Text('ttfahad2317@gmail.com'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              final intent = AndroidIntent(
                action: 'android.intent.action.SENDTO',
                data: 'mailto:ttfahad2317@gmail.com',
              );
              intent.launch();
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Call Support'),
            subtitle: const Text('+91 9072775343'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              final intent = AndroidIntent(
                action: 'android.intent.action.DIAL',
                data: 'tel:+919072775343',
              );
              intent.launch();
            },
          ),
        ],
      ),
    );
  }

  void _openFeedback() {
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'market://details?id=app.in.digital_discipline',
    );
    intent.launch().catchError((e) {
      final webIntent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data:
            'https://play.google.com/store/apps/details?id=app.in.digital_discipline',
      );
      webIntent.launch();
    });
  }

  void _shareApp() {
    Share.share(
      'Check out Intent - Digital Discipline App! It helps you monitor your digital habits and improve your focus. Download it here: https://play.google.com/store/apps/details?id=app.in.digital_discipline',
      subject: 'Improve your Digital Discipline with Intent',
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
