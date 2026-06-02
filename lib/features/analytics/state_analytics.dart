// lib/features/analytics/state_analytics.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/stat_card.dart';
import '../../providers/app_providers.dart';

class StateAnalyticsDashboard extends ConsumerWidget {
  const StateAnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Analytics Dashboard'),
        backgroundColor: AppColors.superAdminColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Grid
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              children: [
                StatCard(title: 'Patients Registered', value: '1,48,750', icon: Icons.people_rounded, color: AppColors.primaryBlue),
                StatCard(title: 'Screened', value: '1,32,480', icon: Icons.remove_red_eye_rounded, color: AppColors.screeningTeamColor),
                StatCard(title: 'Prescriptions', value: '45,620', icon: Icons.description_rounded, color: AppColors.accent),
                StatCard(title: 'Referrals', value: '8,930', icon: Icons.local_hospital_rounded, color: AppColors.error),
                StatCard(title: 'Teleconsults', value: '12,450', icon: Icons.video_call_rounded, color: AppColors.teleDocColor),
                StatCard(title: 'Delivered', value: '38,740', icon: Icons.home_rounded, color: AppColors.success),
              ],
            ),

            const SizedBox(height: 24),

            // Monthly trend chart
            SectionHeader(title: 'Monthly Trend'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patients Registered & Screened (Oct 2023 - Mar 2024)',
                        style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (_) => FlLine(color: theme.colorScheme.outline.withOpacity(0.15), strokeWidth: 1),
                            getDrawingVerticalLine: (_) => FlLine(color: Colors.transparent),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  const labels = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
                                  final i = v.toInt();
                                  if (i >= 0 && i < labels.length) {
                                    return Text(labels[i], style: const TextStyle(fontSize: 10, color: Colors.grey));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: analytics.monthlyData.asMap().entries.map((e) =>
                                  FlSpot(e.key.toDouble(), e.value.patients / 1000)
                              ).toList(),
                              isCurved: true,
                              color: AppColors.primaryBlue,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primaryBlue.withOpacity(0.08),
                              ),
                            ),
                            LineChartBarData(
                              spots: analytics.monthlyData.asMap().entries.map((e) =>
                                  FlSpot(e.key.toDouble(), e.value.screened / 1000)
                              ).toList(),
                              isCurved: true,
                              color: AppColors.screeningTeamColor,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Legend(AppColors.primaryBlue, 'Registered'),
                        const SizedBox(width: 20),
                        _Legend(AppColors.screeningTeamColor, 'Screened'),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            // Disease distribution pie chart
            SectionHeader(title: 'Disease Distribution'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: PieChart(
                        PieChartData(
                          sections: analytics.diseaseDistribution.asMap().entries.map((e) =>
                              PieChartSectionData(
                                value: e.value.percentage,
                                color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                                radius: 50,
                                title: '${e.value.percentage.round()}%',
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                              )
                          ).toList(),
                          centerSpaceRadius: 30,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: analytics.diseaseDistribution.asMap().entries.map((e) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(e.value.disease, style: const TextStyle(fontSize: 11)),
                                  ),
                                  Text('${e.value.percentage.round()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            )
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 300.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 3,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
