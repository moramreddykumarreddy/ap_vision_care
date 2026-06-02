// lib/features/analytics/decision_support.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class DecisionSupportDashboard extends StatelessWidget {
  const DecisionSupportDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision Support'),
        backgroundColor: AppColors.gold,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Critical alerts
            _AlertCard(
              title: 'Critical Alert - Kurnool District',
              message: '45 high-risk patients identified in Kurnool district requiring immediate specialist consultation. AI confidence: 94%',
              severity: 'Critical',
              color: AppColors.error,
              icon: Icons.warning_amber_rounded,
            ),
            const SizedBox(height: 10),
            _AlertCard(
              title: 'Resource Reallocation Suggested',
              message: 'West Godavari district has high DR prevalence (31%). Recommend deploying additional Tele-Ophthal resources.',
              severity: 'High Priority',
              color: AppColors.warning,
              icon: Icons.swap_horiz_rounded,
            ),
            const SizedBox(height: 10),
            _AlertCard(
              title: 'Camp Coverage Gap',
              message: 'Tribal areas in Visakhapatnam district show 68% coverage. 3 habitations yet to be covered this month.',
              severity: 'Medium',
              color: AppColors.primaryBlue,
              icon: Icons.holiday_village_rounded,
            ),

            const SizedBox(height: 20),

            SectionHeader(title: 'Policy Recommendations'),
            const SizedBox(height: 12),

            ...[
              _Policy(
                'Increase Tele-Ophthalmology Coverage',
                'Current ratio: 1:18,000 patients. Recommend: 1:12,000 for optimal care delivery.',
                Icons.video_call_rounded,
                AppColors.teleDocColor,
                'HIGH',
              ),
              _Policy(
                'Spectacle Distribution Optimization',
                'Delivery SLA breached in 3 districts. Consider local optical center partnerships.',
                Icons.visibility_rounded,
                AppColors.accent,
                'MEDIUM',
              ),
              _Policy(
                'Early DR Intervention Protocol',
                '12% increase in DR cases in diabetic patients. Recommend bi-annual screening for all diabetics.',
                Icons.water_drop_rounded,
                AppColors.error,
                'HIGH',
              ),
              _Policy(
                'School Vision Program Expansion',
                'Current coverage: 67% of government schools. Target: 100% coverage by March 2025.',
                Icons.school_rounded,
                AppColors.screeningTeamColor,
                'MEDIUM',
              ),
            ].mapIndexed((i, policy) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: policy.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(policy.icon, color: policy.color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(policy.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: policy.priority == 'HIGH' ? AppColors.error.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    policy.priority,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: policy.priority == 'HIGH' ? AppColors.error : AppColors.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(policy.description, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.check, size: 14),
                                  label: const Text('Approve', style: TextStyle(fontSize: 11)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.send, size: 14),
                                  label: const Text('Forward', style: TextStyle(fontSize: 11)),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
            }),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final String severity;
  final Color color;
  final IconData icon;

  const _AlertCard({
    required this.title,
    required this.message,
    required this.severity,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color))),
                    StatusBadge(label: severity, color: color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _Policy {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String priority;

  const _Policy(this.title, this.description, this.icon, this.color, this.priority);
}

extension IndexedMap4<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
