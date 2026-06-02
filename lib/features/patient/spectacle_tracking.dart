// lib/features/patient/spectacle_tracking.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class SpectacleTracking extends StatelessWidget {
  const SpectacleTracking({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      _TrackingStep(
        title: 'Prescription Approved',
        subtitle: 'By Nodal Officer • 15 Mar 2024',
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Vendor Assigned',
        subtitle: 'Sri Opticals, Vijayawada • 16 Mar 2024',
        icon: Icons.storefront_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Manufacturing',
        subtitle: 'Lens cutting & polishing • 17 Mar 2024',
        icon: Icons.precision_manufacturing_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Quality Check',
        subtitle: 'Passed inspection • 19 Mar 2024',
        icon: Icons.verified_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Dispatched',
        subtitle: 'Shipped via courier • 20 Mar 2024',
        icon: Icons.local_shipping_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Delivered',
        subtitle: 'Received by patient • 22 Mar 2024',
        icon: Icons.home_rounded,
        color: AppColors.success,
        isDone: true,
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectacle Tracking'),
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.success, AppColors.successLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 44),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Spectacles Delivered!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Order ORD001 • Sri Opticals, Vijayawada',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Delivered on 22 March 2024',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Order details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Divider(height: 16),
                    _DetailRow('Order ID', 'ORD001'),
                    _DetailRow('Lens Type', 'Anti-Reflective'),
                    _DetailRow('Frame Type', 'Full Rim'),
                    _DetailRow('Vendor', 'Sri Opticals, Vijayawada'),
                    _DetailRow('Order Amount', '₹ 450'),
                  ],
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 20),

            Text(
              'Delivery Timeline',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ).animate(delay: 150.ms).fadeIn(),

            const SizedBox(height: 12),

            // Timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, i) {
                final step = steps[i];
                final isFirst = i == 0;
                final isLast = i == steps.length - 1;
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: isFirst,
                  isLast: isLast,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    height: 40,
                    indicator: Container(
                      decoration: BoxDecoration(
                        color: step.isDone
                            ? step.color
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: step.isDone ? step.color : theme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        step.icon,
                        color: step.isDone ? Colors.white : theme.colorScheme.outline,
                        size: 20,
                      ),
                    ),
                  ),
                  beforeLineStyle: LineStyle(
                    color: i > 0 && steps[i - 1].isDone
                        ? AppColors.success
                        : theme.colorScheme.outline.withOpacity(0.3),
                    thickness: 2,
                  ),
                  afterLineStyle: LineStyle(
                    color: step.isDone
                        ? AppColors.success
                        : theme.colorScheme.outline.withOpacity(0.3),
                    thickness: 2,
                  ),
                  endChild: Container(
                    margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: step.isActive
                          ? step.color.withOpacity(0.08)
                          : step.isDone
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: step.isActive
                            ? step.color.withOpacity(0.3)
                            : theme.colorScheme.outline.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: step.isActive ? step.color : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (i * 80).ms).fadeIn().slideX(begin: 0.2, end: 0);
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TrackingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDone;
  final bool isActive;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDone,
    required this.isActive,
  });
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
