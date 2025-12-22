import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

class PermissionRequiredView extends StatelessWidget {
  const PermissionRequiredView({super.key});

  void _openUsageAccessSettings() {
    if (!Platform.isAndroid) return;
    
    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Usage access required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'To reflect your app usage, Intent needs permission to read usage data.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openUsageAccessSettings,
              child: const Text('Enable usage access'),
            ),
          ],
        ),
      ),
    );
  }
}
