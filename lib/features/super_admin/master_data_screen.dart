// lib/features/super_admin/master_data_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Data'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MasterSection(title: 'Districts & Mandals', icon: Icons.map_outlined, count: 13),
          _MasterSection(title: 'Referral Hospitals', icon: Icons.local_hospital_outlined, count: 48),
          _MasterSection(title: 'Nodal Officers', icon: Icons.manage_accounts_outlined, count: 13),
          _MasterSection(title: 'Vendors', icon: Icons.storefront_outlined, count: 24),
          _MasterSection(title: 'Tele-Ophthalmologists', icon: Icons.video_call_outlined, count: 36),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add New Master Record'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }
}

class _MasterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const _MasterSection({required this.title, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primaryBlue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$count records configured'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
