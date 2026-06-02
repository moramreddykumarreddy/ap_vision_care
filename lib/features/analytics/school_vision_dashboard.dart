// lib/features/analytics/school_vision_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class SchoolVisionDashboard extends ConsumerWidget {
  const SchoolVisionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolData = ref.watch(schoolVisionProvider);
    final theme = Theme.of(context);

    final deliveryPct = schoolData.glassesDelivered / (schoolData.needingGlasses == 0 ? 1 : schoolData.needingGlasses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('School Vision Dashboard'),
        backgroundColor: AppColors.screeningTeamColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                StatCard(
                  title: 'Students Screened',
                  value: '${schoolData.totalStudentsScreened}',
                  icon: Icons.school_rounded,
                  color: AppColors.screeningTeamColor,
                ),
                StatCard(
                  title: 'Need Glasses',
                  value: '${schoolData.needingGlasses}',
                  icon: Icons.visibility_rounded,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'Glasses Delivered',
                  value: '${schoolData.glassesDelivered}',
                  icon: Icons.home_rounded,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Pending Delivery',
                  value: '${schoolData.pendingDelivery}',
                  icon: Icons.pending_rounded,
                  color: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Delivery progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Spectacle Delivery Progress', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text('${(deliveryPct * 100).round()}%', style: TextStyle(color: AppColors.screeningTeamColor, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearPercentIndicator(
                      lineHeight: 12,
                      percent: deliveryPct,
                      backgroundColor: AppColors.grey200,
                      progressColor: AppColors.screeningTeamColor,
                      barRadius: const Radius.circular(6),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8),
                    Text('${schoolData.glassesDelivered} of ${schoolData.needingGlasses} students received glasses',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(title: 'School Rankings'),
            const SizedBox(height: 12),

            ...schoolData.schools.asMap().entries.map((e) {
              final school = e.value;
              final pct = school.needingGlasses / (school.studentsScreened == 0 ? 1 : school.studentsScreened);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.screeningTeamColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('${e.key + 1}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.screeningTeamColor))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(school.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _SchoolStat('Screened', '${school.studentsScreened}')),
                          Expanded(child: _SchoolStat('Need Glasses', '${school.needingGlasses}')),
                          Expanded(child: _SchoolStat('Prevalence', '${(pct * 100).round()}%')),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (e.key * 80).ms).fadeIn();
            }),
          ],
        ),
      ),
    );
  }
}

class _SchoolStat extends StatelessWidget {
  final String label;
  final String value;
  const _SchoolStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
