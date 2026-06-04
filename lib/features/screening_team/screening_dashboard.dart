// lib/features/screening_team/screening_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class ScreeningDashboard extends ConsumerWidget {
  const ScreeningDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final camps = ref.watch(campsProvider);
    final activeCamp = ref.watch(activeCampProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Screening Team', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(
              'Dr. Srinivasa Rao • Team Lead',
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
        backgroundColor: AppColors.screeningTeamColor,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () => context.go('/screening/settings')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Camp Banner
              if (activeCamp != null)
                _ActiveCampBanner(camp: activeCamp)
                    .animate()
                    .fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              SectionHeader(title: "Today's Summary"),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    title: 'Patients Registered',
                    value: '${activeCamp?.totalRegistered ?? 145}',
                    icon: Icons.how_to_reg_rounded,
                    color: AppColors.screeningTeamColor,
                  ),
                  StatCard(
                    title: 'Patients Screened',
                    value: '${activeCamp?.totalScreened ?? 132}',
                    icon: Icons.remove_red_eye_rounded,
                    color: AppColors.primaryBlue,
                    subtitle: '91%',
                  ),
                  StatCard(
                    title: 'Prescriptions',
                    value: '${activeCamp?.prescriptionsGenerated ?? 48}',
                    icon: Icons.description_rounded,
                    color: AppColors.accent,
                  ),
                  StatCard(
                    title: 'Referrals',
                    value: '${activeCamp?.referrals ?? 12}',
                    icon: Icons.local_hospital_rounded,
                    color: AppColors.warning,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions
              SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),

              Row(
                children: [
                  _QuickActionBtn(
                    icon: Icons.person_add_rounded,
                    label: 'Register\nPatient',
                    color: AppColors.screeningTeamColor,
                    onTap: () => context.go('/screening/register'),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionBtn(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan\nQR',
                    color: AppColors.primaryBlue,
                    onTap: () => context.go('/screening/search'),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionBtn(
                    icon: Icons.search_rounded,
                    label: 'Search\nPatient',
                    color: AppColors.accent,
                    onTap: () => context.go('/screening/search'),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionBtn(
                    icon: Icons.holiday_village_rounded,
                    label: 'Manage\nCamp',
                    color: AppColors.gold,
                    onTap: () => context.go('/screening/camps'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SectionHeader(
                title: 'Camps',
                actionLabel: 'View All',
                onAction: () => context.go('/screening/camps'),
              ),
              const SizedBox(height: 12),

              ...camps.take(2).map((c) => _CampCard(camp: c)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/screening/register'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('New Patient'),
        backgroundColor: AppColors.screeningTeamColor,
      ),
    );
  }
}

class _ActiveCampBanner extends StatelessWidget {
  final dynamic camp;
  const _ActiveCampBanner({required this.camp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.holiday_village, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● ACTIVE CAMP',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  camp.name,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${camp.mandal}, ${camp.district} • ${camp.date}',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${camp.totalRegistered}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                'Patients',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampCard extends StatelessWidget {
  final dynamic camp;
  const _CampCard({required this.camp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    camp.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                StatusBadge(label: camp.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${camp.mandal}, ${camp.district} • ${camp.date}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric('Registered', '${camp.totalRegistered}'),
                _Metric('Screened', '${camp.totalScreened}'),
                _Metric('Prescriptions', '${camp.prescriptionsGenerated}'),
                _Metric('Referrals', '${camp.referrals}'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500])),
      ],
    );
  }
}
