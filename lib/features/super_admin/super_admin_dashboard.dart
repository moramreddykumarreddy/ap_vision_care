// lib/features/super_admin/super_admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class SuperAdminDashboard extends ConsumerWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final districts = ref.watch(districtsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Super Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('AP Vision Program • State View', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.superAdminColor,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // State KPI Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryBlue, Color(0xFF2952A3)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Andhra Pradesh State Overview', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Programme Year 2024-25 • Updated Today', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _KpiChip('${(analytics.totalPatients / 1000).round()}K', 'Patients'),
                      _KpiChip('${(analytics.totalScreened / 1000).round()}K', 'Screened'),
                      _KpiChip('${(analytics.totalPrescriptions / 1000).round()}K', 'Rx Given'),
                      _KpiChip('${(analytics.spectaclesDelivered / 1000).round()}K', 'Delivered'),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: 'Total Referrals',
                  value: '${analytics.totalReferrals}',
                  icon: Icons.local_hospital_rounded,
                  color: AppColors.error,
                  onTap: () => context.go('/admin/referrals'),
                ),
                StatCard(
                  title: 'Teleconsultations',
                  value: '${analytics.teleconsultations}',
                  icon: Icons.video_call_rounded,
                  color: AppColors.teleDocColor,
                ),
                StatCard(
                  title: 'Districts Active',
                  value: '13',
                  icon: Icons.map_rounded,
                  color: AppColors.superAdminColor,
                  onTap: () => context.go('/admin/analytics/district'),
                ),
                StatCard(
                  title: 'Camps This Month',
                  value: '248',
                  icon: Icons.holiday_village_rounded,
                  color: AppColors.screeningTeamColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Analytics quick links
            SectionHeader(title: 'Analytics Modules'),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: [
                _AnalyticsQuickLink('State\nAnalytics', Icons.bar_chart_rounded, AppColors.primaryBlue, () => context.go('/admin/analytics/state')),
                _AnalyticsQuickLink('District\nView', Icons.map_rounded, AppColors.screeningTeamColor, () => context.go('/admin/analytics/district')),
                _AnalyticsQuickLink('AI\nRisk', Icons.auto_awesome_rounded, AppColors.superAdminColor, () => context.go('/admin/analytics/ai')),
                _AnalyticsQuickLink('Nutrition\nRisk', Icons.restaurant_rounded, AppColors.warning, () => context.go('/admin/analytics/nutrition')),
                _AnalyticsQuickLink('School\nVision', Icons.school_rounded, AppColors.accent, () => context.go('/admin/analytics/school')),
                _AnalyticsQuickLink('Decision\nSupport', Icons.gavel_rounded, AppColors.gold, () => context.go('/admin/analytics/decision')),
              ],
            ),

            const SizedBox(height: 24),

            // Top performing districts
            SectionHeader(
              title: 'District Rankings',
              actionLabel: 'View All',
              onAction: () => context.go('/admin/analytics/district'),
            ),
            const SizedBox(height: 12),

            ...districts.take(5).mapIndexed((i, d) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: i == 0 ? AppColors.gold : i == 1 ? AppColors.grey300 : AppColors.warning.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${i + 1}', style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: i == 0 ? Colors.white : AppColors.grey700,
                          fontSize: 14,
                        )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          Text('${d.screened} screened', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${d.coverage}%', style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: d.coverage >= 85 ? AppColors.success : AppColors.warning,
                        )),
                        Text('Coverage', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate(delay: (i * 60).ms).fadeIn()),
          ],
        ),
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  final String value;
  final String label;
  const _KpiChip(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
      ],
    );
  }
}

class _AnalyticsQuickLink extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AnalyticsQuickLink(this.label, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}



extension IndexedMap2<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
