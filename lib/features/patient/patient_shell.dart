// lib/features/patient/patient_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientShell extends StatelessWidget {
  final Widget child;
  const PatientShell({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home', path: '/patient/dashboard'),
    (icon: Icons.description_rounded, label: 'Prescriptions', path: '/patient/prescriptions'),
    (icon: Icons.visibility_rounded, label: 'Spectacles', path: '/patient/spectacles'),
    (icon: Icons.local_hospital_rounded, label: 'Referrals', path: '/patient/referrals'),
    (icon: Icons.video_call_rounded, label: 'Tele', path: '/patient/teleconsultation'),
    (icon: Icons.person_rounded, label: 'Profile', path: '/patient/profile'),
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
