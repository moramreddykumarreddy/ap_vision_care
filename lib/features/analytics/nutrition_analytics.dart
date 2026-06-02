// lib/features/analytics/nutrition_analytics.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class NutritionAnalytics extends StatelessWidget {
  const NutritionAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Analytics'),
        backgroundColor: AppColors.warning,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Risk summary
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                _NutriCard('Vitamin A\nDeficiency', '23.4%', Icons.visibility_outlined, AppColors.warning),
                _NutriCard('Vitamin D\nDeficiency', '31.2%', Icons.wb_sunny_outlined, AppColors.gold),
                _NutriCard('Anaemia\nPrevalence', '28.6%', Icons.bloodtype_outlined, AppColors.error),
                _NutriCard('Malnutrition\nRisk', '19.1%', Icons.restaurant_outlined, AppColors.screeningTeamColor),
              ],
            ),
            const SizedBox(height: 20),

            SectionHeader(title: 'Diet Pattern by District'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vitamin A Deficiency Trend', style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
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
                                const labels = ['Kur', 'Srik', 'VSP', 'GNT', 'KR', 'NLR'];
                                final i = v.toInt();
                                return i < labels.length
                                    ? Text(labels[i], style: const TextStyle(fontSize: 9, color: Colors.grey))
                                    : const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [28.0, 31.0, 19.0, 22.0, 17.0, 26.0].asMap().entries.map((e) =>
                            BarChartGroupData(x: e.key, barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: AppColors.warning,
                                width: 20,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                              ),
                            ])
                        ).toList(),
                        maxY: 40,
                      )),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(title: 'Intervention Recommendations'),
            const SizedBox(height: 12),

            ...[
              ('Vitamin A Supplementation', 'Target high-deficiency districts immediately', Icons.medication, AppColors.warning),
              ('Iron-Folic Acid Distribution', 'Expand to all pregnant women and children', Icons.local_pharmacy, AppColors.error),
              ('Nutrition Education Camps', 'Organize in rural and tribal areas', Icons.school, AppColors.screeningTeamColor),
              ('Diet Diversity Programs', 'Promote leafy vegetables and eggs', Icons.restaurant, AppColors.success),
            ].map((item) {
              final (title, desc, icon, color) = item;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  subtitle: Text(desc, style: const TextStyle(fontSize: 11)),
                ),
              ).animate().fadeIn();
            }),
          ],
        ),
      ),
    );
  }
}

class _NutriCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _NutriCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
            Text(title, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
