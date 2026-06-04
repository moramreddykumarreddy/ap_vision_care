// lib/features/analytics/mandal_dashboard.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/stat_card.dart';

class MandalDashboard extends StatelessWidget {
  const MandalDashboard({super.key});

  static const _mandals = [
    ('Vijayawada Urban', 92, 48, 12),
    ('Machilipatnam', 78, 35, 8),
    ('Nuzvid', 71, 28, 15),
    ('Gudivada', 84, 41, 6),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandal Dashboard'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(title: 'Krishna District — Mandal Coverage'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              StatCard(title: 'Camps Active', value: '18', icon: Icons.campaign, color: AppColors.primaryBlue),
              StatCard(title: 'Pending Deliveries', value: '41', icon: Icons.local_shipping, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),
          ..._mandals.map((m) {
            final (name, coverage, screened, pending) = m;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: coverage / 100, backgroundColor: AppColors.grey200, color: AppColors.success),
                    const SizedBox(height: 8),
                    Text('$coverage% coverage • $screened camps • $pending pending deliveries',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
