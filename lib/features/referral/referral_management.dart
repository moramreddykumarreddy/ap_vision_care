// lib/features/referral/referral_management.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class ReferralManagement extends ConsumerStatefulWidget {
  const ReferralManagement({super.key});

  @override
  ConsumerState<ReferralManagement> createState() => _ReferralManagementState();
}

class _ReferralManagementState extends ConsumerState<ReferralManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final referrals = ref.watch(referralsProvider);
    final theme = Theme.of(context);

    final pending = referrals.where((r) => r.status == 'Pending').toList();
    final accepted = referrals.where((r) => r.status == 'Accepted').toList();
    final completed = referrals.where((r) => r.status == 'Completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Management'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Accepted (${accepted.length})'),
            Tab(text: 'Completed (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReferralList(referrals: pending, showActions: true),
          _ReferralList(referrals: accepted),
          _ReferralList(referrals: completed),
        ],
      ),
    );
  }
}

class _ReferralList extends StatelessWidget {
  final List referrals;
  final bool showActions;

  const _ReferralList({required this.referrals, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    if (referrals.isEmpty) {
      return const EmptyState(icon: Icons.local_hospital, title: 'No referrals', message: 'No referrals in this category');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: referrals.length,
      itemBuilder: (context, i) {
        final r = referrals[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: r.priority == 'Urgent' ? AppColors.error.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_hospital_rounded,
                        color: r.priority == 'Urgent' ? AppColors.error : AppColors.warning,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.patientName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(r.condition, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                    StatusBadge(
                      label: r.priority,
                      color: r.priority == 'Urgent' ? AppColors.error : AppColors.warning,
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  children: [
                    Expanded(child: InfoRow(label: 'Hospital', value: r.hospital)),
                    Expanded(child: InfoRow(label: 'Referred By', value: r.doctorName)),
                  ],
                ),
                InfoRow(label: 'Date', value: r.date),

                if (showActions) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check, size: 15),
                          label: const Text('Accept', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.schedule, size: 15),
                          label: const Text('Schedule', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          minimumSize: Size.zero,
                        ),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
      },
    );
  }
}
