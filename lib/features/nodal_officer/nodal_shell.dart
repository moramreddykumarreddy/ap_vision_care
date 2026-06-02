// lib/features/nodal_officer/nodal_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NodalShell extends StatelessWidget {
  final Widget child;
  const NodalShell({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', path: '/nodal/dashboard'),
    (icon: Icons.group_rounded, label: 'Teams', path: '/nodal/teams'),
    (icon: Icons.approval_rounded, label: 'Approvals', path: '/nodal/approvals'),
    (icon: Icons.storefront_rounded, label: 'Vendors', path: '/nodal/vendors'),
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
        destinations: _tabs.map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label)).toList(),
      ),
    );
  }
}
