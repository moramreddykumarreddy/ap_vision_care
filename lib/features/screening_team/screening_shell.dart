// lib/features/screening_team/screening_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreeningShell extends StatelessWidget {
  final Widget child;
  const ScreeningShell({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', path: '/screening/dashboard'),
    (icon: Icons.holiday_village_rounded, label: 'Camps', path: '/screening/camps'),
    (icon: Icons.search_rounded, label: 'Search', path: '/screening/search'),
    (icon: Icons.person_add_rounded, label: 'Register', path: '/screening/register'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs.map((t) => NavigationDestination(
          icon: Icon(t.icon),
          label: t.label,
        )).toList(),
      ),
    );
  }
}
