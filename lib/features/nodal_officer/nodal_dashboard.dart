// lib/features/nodal_officer/nodal_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class NodalDashboard extends ConsumerWidget {
  const NodalDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prescriptions = ref.watch(prescriptionsProvider);
    final referrals = ref.watch(referralsProvider);
    final orders = ref.watch(vendorOrdersProvider);

    final pendingApprovals = prescriptions.where((p) => p.status == 'Pending').length;
    final pendingReferrals = referrals.where((r) => r.status == 'Pending').length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nodal Officer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('Krishna District', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.nodalOfficerColor,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () => context.go('/nodal/settings')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // District summary banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.nodalOfficerColor, AppColors.nodalOfficerColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Krishna District Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        Text('Last updated: Today 02:30 PM', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                      ],
                    ),
                  ),
                  if (pendingApprovals > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$pendingApprovals Pending',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            SectionHeader(title: 'District Summary'),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  title: 'Total Patients',
                  value: '15,200',
                  icon: Icons.people_rounded,
                  color: AppColors.nodalOfficerColor,
                ),
                StatCard(
                  title: 'Pending Approvals',
                  value: '$pendingApprovals',
                  icon: Icons.pending_actions_rounded,
                  color: AppColors.warning,
                  subtitle: 'Action Required',
                  onTap: () => context.go('/nodal/approvals'),
                ),
                StatCard(
                  title: 'Active Orders',
                  value: '${orders.length}',
                  icon: Icons.shopping_bag_rounded,
                  color: AppColors.accent,
                  onTap: () => context.go('/nodal/vendors'),
                ),
                StatCard(
                  title: 'Referrals',
                  value: '${referrals.length}',
                  icon: Icons.local_hospital_rounded,
                  color: AppColors.error,
                  subtitle: '$pendingReferrals pending',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Pending Approvals Alert
            if (pendingApprovals > 0)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pending Prescriptions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('$pendingApprovals prescriptions awaiting your approval', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/nodal/approvals'),
                      child: const Text('Review'),
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(
              title: 'Recent Prescriptions',
              actionLabel: 'View All',
              onAction: () => context.go('/nodal/approvals'),
            ),
            const SizedBox(height: 12),

            ...prescriptions.take(3).map((rx) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.nodalOfficerColor.withOpacity(0.1),
                  child: Text(rx.patientName[0], style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.nodalOfficerColor)),
                ),
                title: Text(rx.patientName, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${rx.diagnosis} • ${rx.date}'),
                trailing: StatusBadge(label: rx.status),
              ),
            ).animate().fadeIn()),
          ],
        ),
      ),
    );
  }
}
