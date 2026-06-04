// lib/features/analytics/ai_analytics.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class AiAnalyticsDashboard extends ConsumerWidget {
  const AiAnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiData = ref.watch(aiRiskProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analytics'),
        backgroundColor: AppColors.superAdminColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.heroGradient,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI Risk Intelligence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        Text('Based on ${aiData.totalAnalyzed.toString().replaceAll(RegExp(r'(?<=\d)(?=(\d{3})+$)'), ',')} patients analyzed',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                        Text('${aiData.highRiskPatients} high-risk patients identified',
                            style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            SectionHeader(title: 'Disease Risk Scores'),
            const SizedBox(height: 16),

            // Risk cards grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              children: [
                _RiskCard('Cataract Risk', aiData.catarackRisk, AppColors.warning, Icons.wb_cloudy_rounded),
                _RiskCard('Glaucoma Risk', aiData.glaucomaRisk, AppColors.primaryBlue, Icons.remove_red_eye_rounded),
                _RiskCard('Diabetic\nRetinopathy', aiData.diabeticRetinopathyRisk, AppColors.error, Icons.water_drop_rounded),
                _RiskCard('Blindness Risk', aiData.blindnessRisk, AppColors.superAdminColor, Icons.visibility_off_rounded),
              ],
            ),

            const SizedBox(height: 24),

            // Heatmap placeholder
            SectionHeader(title: 'Disease Hotspot Heatmap'),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          center: Alignment.center,
                          radius: 0.8,
                          colors: [AppColors.brandRed, AppColors.brandGray, AppColors.brandBlue],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_rounded, color: Colors.white, size: 40),
                            const SizedBox(height: 8),
                            const Text('Disease Hotspot Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            Text('High: Red | Medium: Orange | Low: Green', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            SectionHeader(title: 'Village-Level Rankings'),
            const SizedBox(height: 12),

            ...[
              ('Palakol Village', 'West Godavari', 0.72, AppColors.error),
              ('Narasapur', 'West Godavari', 0.61, AppColors.warning),
              ('Eluru', 'West Godavari', 0.48, AppColors.warning),
              ('Bhimavaram', 'West Godavari', 0.32, AppColors.success),
            ].mapIndexed((i, entry) {
              final (village, district, risk, color) = entry;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                        child: Center(child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 12))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(village, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text(district, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${(risk * 100).round()}%', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 14)),
                          const Text('Risk Score', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 60).ms).fadeIn();
            }),
          ],
        ),
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final String title;
  final double risk;
  final Color color;
  final IconData icon;

  const _RiskCard(this.title, this.risk, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 44,
              lineWidth: 7,
              percent: risk / 100,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 18),
                  Text('${risk.round()}%', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 13)),
                ],
              ),
              progressColor: color,
              backgroundColor: color.withOpacity(0.12),
            ),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

extension IndexedMap3<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
