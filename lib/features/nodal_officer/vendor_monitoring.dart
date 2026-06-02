// lib/features/nodal_officer/vendor_monitoring.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class VendorMonitoring extends ConsumerWidget {
  const VendorMonitoring({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(vendorOrdersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Monitoring'),
        backgroundColor: AppColors.nodalOfficerColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor summary cards
            SectionHeader(title: 'Active Vendors'),
            const SizedBox(height: 12),

            ...[
              _VendorData('Sri Opticals, Vijayawada', 45, 38, 0.95, 'On Track'),
              _VendorData('Vision Plus, Tirupati', 32, 28, 0.87, 'At Risk'),
              _VendorData('National Optical, Guntur', 28, 21, 0.75, 'Delayed'),
            ].mapIndexed((i, v) => _VendorCard(vendor: v, index: i)),

            const SizedBox(height: 20),

            // Orders List
            SectionHeader(title: 'Order Status'),
            const SizedBox(height: 12),

            ...orders.map((order) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.vendorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: AppColors.vendorColor, size: 22),
                ),
                title: Text(order.patientName, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${order.vendorName}\n${order.lensType} • ₹${order.amount}'),
                trailing: StatusBadge(label: order.status),
                isThreeLine: true,
              ),
            ).animate().fadeIn()),
          ],
        ),
      ),
    );
  }
}

class _VendorData {
  final String name;
  final int totalOrders;
  final int completed;
  final double slaScore;
  final String performance;

  const _VendorData(this.name, this.totalOrders, this.completed, this.slaScore, this.performance);
}

class _VendorCard extends StatelessWidget {
  final _VendorData vendor;
  final int index;
  const _VendorCard({required this.vendor, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color perfColor = vendor.performance == 'On Track'
        ? AppColors.success
        : vendor.performance == 'At Risk'
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // SLA indicator
            CircularPercentIndicator(
              radius: 36,
              lineWidth: 5,
              percent: vendor.slaScore,
              center: Text(
                '${(vendor.slaScore * 100).round()}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: perfColor),
              ),
              progressColor: perfColor,
              backgroundColor: perfColor.withOpacity(0.12),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _OrderStat('Total', '${vendor.totalOrders}'),
                      const SizedBox(width: 12),
                      _OrderStat('Done', '${vendor.completed}'),
                      const SizedBox(width: 12),
                      _OrderStat('Pending', '${vendor.totalOrders - vendor.completed}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  StatusBadge(label: vendor.performance),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 80).ms).fadeIn().slideX(begin: 0.2, end: 0);
  }
}

class _OrderStat extends StatelessWidget {
  final String label;
  final String value;
  const _OrderStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}

extension IndexedMap<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
