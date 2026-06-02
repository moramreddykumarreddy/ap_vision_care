// lib/features/tele_ophthalmologist/tele_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeleShell extends StatelessWidget {
  final Widget child;
  const TeleShell({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', path: '/tele/dashboard'),
    (icon: Icons.list_alt_rounded, label: 'Consultations', path: '/tele/consultations'),
    (icon: Icons.video_call_rounded, label: 'Video', path: '/tele/video'),
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
