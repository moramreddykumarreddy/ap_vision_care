// lib/features/analytics/elderly_care_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';

class ElderlyCare extends StatelessWidget {
  const ElderlyCare({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elderly Care Dashboard'),
        backgroundColor: const Color(0xFF6D4C41),
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
                StatCard(title: 'Elderly Registered\n(60+ years)', value: '23,450', icon: Icons.elderly_rounded, color: const Color(0xFF6D4C41)),
                StatCard(title: 'Blind Registered', value: '1,280', icon: Icons.visibility_off_rounded, color: AppColors.error),
                StatCard(title: 'Cataract Cases', value: '8,940', icon: Icons.wb_cloudy_rounded, color: AppColors.warning),
                StatCard(title: 'Home Care Given', value: '3,210', icon: Icons.home_rounded, color: AppColors.success),
              ],
            ),

            const SizedBox(height: 20),

            SectionHeader(title: 'Age Distribution'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: BarChart(BarChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const labels = ['60-64', '65-69', '70-74', '75-79', '80-84', '85+'];
                            final i = v.toInt();
                            return i < labels.length
                                ? Text(labels[i], style: const TextStyle(fontSize: 9, color: Colors.grey))
                                : const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [38.0, 27.0, 18.0, 10.0, 5.0, 2.0].asMap().entries.map((e) =>
                        BarChartGroupData(x: e.key, barRods: [
                          BarChartRodData(
                            toY: e.value,
                            color: const Color(0xFF6D4C41),
                            width: 24,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                          ),
                        ])
                    ).toList(),
                  )),
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(title: 'Common Conditions (60+)'),
            const SizedBox(height: 12),

            ...[
              ('Cataract', 38.1, AppColors.warning),
              ('Age-Related Macular Degeneration', 22.3, AppColors.error),
              ('Diabetic Retinopathy', 18.7, AppColors.primaryBlue),
              ('Glaucoma', 13.4, AppColors.superAdminColor),
              ('Corneal Diseases', 7.5, AppColors.screeningTeamColor),
            ].map((item) {
              final (condition, pct, color) = item;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(condition, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('${pct}%', style: TextStyle(fontWeight: FontWeight.w800, color: color)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          backgroundColor: color.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn();
            }),
          ],
        ),
      ),
    );
  }
}
