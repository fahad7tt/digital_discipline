import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Intent does not collect, store, or transmit any personal data.\n\n'
          'All information remains on your device.\n\n'
          'No tracking. No analytics. No ads.',
        ),
      ),
    );
  }
}
