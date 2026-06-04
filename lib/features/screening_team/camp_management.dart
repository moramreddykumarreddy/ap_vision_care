// lib/features/screening_team/camp_management.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class CampManagement extends ConsumerWidget {
  const CampManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camps = ref.watch(campsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Management'),
        backgroundColor: AppColors.screeningTeamColor,
        leading: const AppBarBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showStartCampDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: camps.length,
        itemBuilder: (context, i) {
          final camp = camps[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: camp.status == 'Active'
                        ? AppColors.screeningTeamColor.withOpacity(0.08)
                        : camp.status == 'Scheduled'
                            ? AppColors.primaryBlue.withOpacity(0.06)
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: camp.status == 'Active'
                              ? AppColors.screeningTeamColor.withOpacity(0.15)
                              : AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.holiday_village,
                          color: camp.status == 'Active'
                              ? AppColors.screeningTeamColor
                              : AppColors.primaryBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              camp.name,
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              camp.date,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(label: camp.status),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${camp.village}, ${camp.mandal}, ${camp.district}',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            camp.teamLead,
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Progress metrics
                      if (camp.totalRegistered > 0) ...[
                        Row(
                          children: [
                            Expanded(child: _CampMetric('Registered', '${camp.totalRegistered}', AppColors.primaryBlue)),
                            Expanded(child: _CampMetric('Screened', '${camp.totalScreened}', AppColors.screeningTeamColor)),
                            Expanded(child: _CampMetric('Prescriptions', '${camp.prescriptionsGenerated}', AppColors.accent)),
                            Expanded(child: _CampMetric('Referrals', '${camp.referrals}', AppColors.warning)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Coverage progress bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Screening Progress', style: theme.textTheme.labelSmall),
                                Text(
                                  '${((camp.totalScreened / (camp.totalRegistered == 0 ? 1 : camp.totalRegistered)) * 100).round()}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.screeningTeamColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: camp.totalRegistered > 0
                                    ? camp.totalScreened / camp.totalRegistered
                                    : 0,
                                backgroundColor: AppColors.grey200,
                                valueColor: const AlwaysStoppedAnimation(AppColors.screeningTeamColor),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Action buttons
                      Row(
                        children: [
                          if (camp.status == 'Active')
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.stop_rounded, size: 16),
                                label: const Text('End Camp'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                              ),
                            )
                          else if (camp.status == 'Scheduled')
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.play_arrow_rounded, size: 16),
                                label: const Text('Start Camp'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.screeningTeamColor,
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('View Report'),
                              ),
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
        },
      ),
    );
  }

  void _showStartCampDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Camp'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Camp Type', prefixIcon: Icon(Icons.category_outlined)),
                items: const [
                  'Village', 'Tribal Area', 'Urban Slum', 'Semi-Urban', 'School',
                  'Government Institution', 'Industrial Area',
                ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Camp Name', prefixIcon: Icon(Icons.holiday_village))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'District', prefixIcon: Icon(Icons.map))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Mandal', prefixIcon: Icon(Icons.location_on))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Village / Habitation', prefixIcon: Icon(Icons.cottage))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Scheduled Date', prefixIcon: Icon(Icons.calendar_today))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create Camp'),
          ),
        ],
      ),
    );
  }
}

class _CampMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _CampMetric(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
