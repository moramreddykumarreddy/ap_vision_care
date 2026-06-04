// lib/features/super_admin/super_admin_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class SuperAdminShell extends ConsumerWidget {
  final Widget child;
  const SuperAdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width <= 768;

    return Scaffold(
      key: ref.read(adminScaffoldKeyProvider),
      drawer: isMobile ? const AdminDrawer() : null,
      body: Row(
        children: [
          // Side rail for tablets/desktops
          if (!isMobile)
            _AdminSideRail(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AdminSideRail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 220,
      color: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.visibility, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('AP Vision', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.darkBorder),

            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _menuItems.map((item) {
                  final isSelected = location.startsWith(item.path);
                  return _SideRailItem(item: item, isSelected: isSelected);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideRailItem extends StatelessWidget {
  final _MenuItem item;
  final bool isSelected;
  const _SideRailItem({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: isSelected ? AppColors.accent : Colors.white54, size: 20),
      title: Text(
        item.label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.accent.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => context.go(item.path),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.visibility, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AP Vision Program', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      Text('Super Admin', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.darkBorder),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  final isSelected = location.startsWith(item.path);
                  return ListTile(
                    leading: Icon(item.icon, color: isSelected ? AppColors.accent : Colors.white54, size: 20),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppColors.accent.withOpacity(0.12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.path);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String path;
  const _MenuItem(this.icon, this.label, this.path);
}

const _menuItems = [
  _MenuItem(Icons.dashboard_rounded, 'Dashboard', '/admin/dashboard'),
  _MenuItem(Icons.bar_chart_rounded, 'State Analytics', '/admin/analytics/state'),
  _MenuItem(Icons.map_rounded, 'District View', '/admin/analytics/district'),
  _MenuItem(Icons.place_rounded, 'Mandal View', '/admin/analytics/mandal'),
  _MenuItem(Icons.diversity_3_rounded, 'Demographics', '/admin/analytics/demographics'),
  _MenuItem(Icons.auto_awesome_rounded, 'AI Analytics', '/admin/analytics/ai'),
  _MenuItem(Icons.restaurant_rounded, 'Nutrition', '/admin/analytics/nutrition'),
  _MenuItem(Icons.school_rounded, 'School Vision', '/admin/analytics/school'),
  _MenuItem(Icons.elderly_rounded, 'Elderly Care', '/admin/analytics/elderly'),
  _MenuItem(Icons.gavel_rounded, 'Decision Support', '/admin/analytics/decision'),
  _MenuItem(Icons.timeline_rounded, 'EMR', '/admin/emr'),
  _MenuItem(Icons.folder_open_rounded, 'Documents', '/admin/documents'),
  _MenuItem(Icons.local_hospital_rounded, 'Referrals', '/admin/referrals'),
  _MenuItem(Icons.storage_rounded, 'Master Data', '/admin/master-data'),
  _MenuItem(Icons.history_rounded, 'Audit Logs', '/admin/audit'),
  _MenuItem(Icons.smart_toy_rounded, 'AI Config', '/admin/ai-config'),
  _MenuItem(Icons.summarize_rounded, 'Reports', '/admin/reports'),
  _MenuItem(Icons.settings_rounded, 'Settings', '/admin/settings'),
];
