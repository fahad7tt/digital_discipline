import 'package:flutter/material.dart';
import '../dashboard/presentation/screens/dashboard_screen.dart';
import '../digital_app/presentation/screens/digital_app_screen.dart';
import '../insights/presentation/screens/insights_screen.dart';
import '../usage_logging/presentation/screens/usage_log_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // List of screens for bottom nav
  final List<({String label, IconData icon, Widget screen})> _screens = const [
    (label: 'Dashboard', icon: Icons.home, screen: DashboardScreen()),
    (label: 'Apps', icon: Icons.apps, screen: DigitalAppScreen()),
    (label: 'Usage', icon: Icons.timer, screen: UsageLogScreen(focusAppId: '', focusAppName: 'All Apps')),
    (label: 'Insights', icon: Icons.insights, screen: InsightsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens.map((s) => s.screen).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: _screens
            .map(
              (s) => BottomNavigationBarItem(
                icon: Icon(s.icon),
                label: s.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
