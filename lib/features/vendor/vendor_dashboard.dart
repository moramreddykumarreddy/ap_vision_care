// lib/features/vendor/vendor_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class VendorDashboard extends ConsumerWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(vendorOrdersProvider);
    final theme = Theme.of(context);

    final manufacturing = orders.where((o) => o.status == 'Manufacturing').length;
    final dispatched = orders.where((o) => o.status == 'Dispatched').length;
    final delivered = orders.where((o) => o.status == 'Delivered').length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vendor Portal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('Sri Opticals, Vijayawada', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.vendorColor,
        actions: [
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () => context.go('/vendor/settings')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SLA status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.vendorColor, AppColors.vendorColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SLA Compliance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                        Text('${orders.length} active orders', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.95,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('95%', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            SectionHeader(title: 'Order Pipeline'),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  title: 'Total Orders',
                  value: '${orders.length}',
                  icon: Icons.shopping_bag_rounded,
                  color: AppColors.vendorColor,
                ),
                StatCard(
                  title: 'Manufacturing',
                  value: '$manufacturing',
                  icon: Icons.precision_manufacturing_rounded,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'Dispatched',
                  value: '$dispatched',
                  icon: Icons.local_shipping_rounded,
                  color: AppColors.primaryBlue,
                ),
                StatCard(
                  title: 'Delivered',
                  value: '$delivered',
                  icon: Icons.home_rounded,
                  color: AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: 20),

            SectionHeader(title: 'Recent Orders'),
            const SizedBox(height: 12),

            ...orders.map((o) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => context.go('/vendor/order/${o.id}'),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.vendorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shopping_bag, color: AppColors.vendorColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o.patientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                Text('${o.lensType} • ${o.frameType}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusBadge(label: o.status),
                              const SizedBox(height: 4),
                              Text('₹${o.amount}', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn()),
          ],
        ),
      ),
    );
  }
}
