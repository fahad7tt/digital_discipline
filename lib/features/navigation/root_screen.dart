import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dashboard/presentation/screens/dashboard_screen.dart';
import '../digital_app/presentation/screens/digital_app_screen.dart';
import '../stats/presentation/screens/stats_screen.dart';
import '../usage_logging/presentation/bloc/usage_log_bloc.dart';
import '../usage_logging/presentation/bloc/usage_log_event.dart';
import '../usage_logging/presentation/screens/usage_overview.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<({String label, IconData icon, Widget screen})> _screens = [
    (label: 'Dashboard', icon: Icons.home, screen: DashboardScreen()),
    (label: 'Apps', icon: Icons.apps, screen: DigitalAppScreen()),
    (label: 'Usage', icon: Icons.timer, screen: UsageOverviewScreen()),
    (label: 'Stats', icon: Icons.insights, screen: StatsScreen()),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // initial load
    context.read<AppUsageBloc>().add(LoadTodayUsage());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔑 CRITICAL: refresh permission + usage when returning from settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AppUsageBloc>().add(RefreshUsage());
    }
  }

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
