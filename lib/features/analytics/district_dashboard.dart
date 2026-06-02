// lib/features/analytics/district_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class DistrictDashboard extends ConsumerWidget {
  const DistrictDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final districts = ref.watch(districtsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('District Dashboard'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A3A6B), Color(0xFF0D2347)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map_rounded, color: Colors.white30, size: 60),
                        const SizedBox(height: 8),
                        const Text('Andhra Pradesh District Heatmap', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('Interactive district coverage map', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                      ],
                    ),
                  ),
                  // Hot spots
                  Positioned(
                    top: 60, left: 80,
                    child: _HeatDot(AppColors.success, 'VSP\n91%'),
                  ),
                  Positioned(
                    top: 100, left: 140,
                    child: _HeatDot(AppColors.success, 'KR\n89%'),
                  ),
                  Positioned(
                    top: 120, right: 80,
                    child: _HeatDot(AppColors.warning, 'NLR\n78%'),
                  ),
                  Positioned(
                    bottom: 50, left: 100,
                    child: _HeatDot(AppColors.error, 'CTR\n75%'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Bar chart
            SectionHeader(title: 'Coverage by District'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
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
                              final i = v.toInt();
                              if (i >= 0 && i < districts.length) {
                                return Transform.rotate(
                                  angle: -0.5,
                                  child: Text(districts[i].name.substring(0, 3), style: const TextStyle(fontSize: 9, color: Colors.grey)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: districts.asMap().entries.map((e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.coverage,
                            color: e.value.coverage >= 85
                                ? AppColors.success
                                : e.value.coverage >= 80
                                    ? AppColors.warning
                                    : AppColors.error,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      )).toList(),
                      maxY: 100,
                    ),
                  ),
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(title: 'District Performance Table'),
            const SizedBox(height: 12),

            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.primaryBlue.withOpacity(0.06)),
                  columns: const [
                    DataColumn(label: Text('Rank', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('District', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('Patients', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('Screened', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('Coverage', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                  ],
                  rows: districts.map((d) => DataRow(
                    cells: [
                      DataCell(Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          color: d.rank <= 3 ? AppColors.gold.withOpacity(0.2) : AppColors.grey100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text('${d.rank}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      )),
                      DataCell(Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                      DataCell(Text('${d.patients}', style: const TextStyle(fontSize: 12))),
                      DataCell(Text('${d.screened}', style: const TextStyle(fontSize: 12))),
                      DataCell(StatusBadge(
                        label: '${d.coverage}%',
                        color: d.coverage >= 85 ? AppColors.success : AppColors.warning,
                      )),
                    ],
                  )).toList(),
                ),
              ),
            ).animate(delay: 300.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _HeatDot extends StatelessWidget {
  final Color color;
  final String label;
  const _HeatDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 16),
        ),
        Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
      ],
    );
  }
}
