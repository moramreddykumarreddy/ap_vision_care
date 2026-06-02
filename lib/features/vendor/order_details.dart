// lib/features/vendor/order_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(vendorOrdersProvider);
    final order = orders.firstWhere((o) => o.id == orderId, orElse: () => orders.first);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id}'),
        backgroundColor: AppColors.vendorColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            _StatusCard(order: order),

            const SizedBox(height: 16),

            // Patient details
            _SectionCard(
              title: 'Patient Details',
              icon: Icons.person_outline,
              children: [
                InfoRow(label: 'Name', value: order.patientName),
                InfoRow(label: 'Rx ID', value: order.prescriptionId),
                InfoRow(label: 'Order ID', value: order.id),
              ],
            ),

            const SizedBox(height: 12),

            // Prescription details
            _SectionCard(
              title: 'Prescription Details',
              icon: Icons.description_outlined,
              children: [
                InfoRow(label: 'Lens Type', value: order.lensType),
                InfoRow(label: 'Frame Type', value: order.frameType),
                InfoRow(label: 'Amount', value: '₹ ${order.amount}'),
              ],
            ),

            const SizedBox(height: 12),

            // Manufacturing status
            _SectionCard(
              title: 'Manufacturing Status',
              icon: Icons.precision_manufacturing_outlined,
              children: [
                InfoRow(label: 'Order Date', value: order.orderDate),
                InfoRow(label: 'Delivery Date', value: order.deliveryDate.isEmpty ? 'Pending' : order.deliveryDate),
                InfoRow(label: 'Vendor', value: order.vendorName),
              ],
            ),

            const SizedBox(height: 16),

            // Update status
            Text('Update Status', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _StatusUpdateChips(currentStatus: order.status),

            const SizedBox(height: 16),

            if (order.status == 'Dispatched' || order.status == 'Delivered')
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.local_shipping, size: 18),
                label: const Text('Mark as Delivered'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final dynamic order;
  const _StatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.vendorColor, AppColors.vendorColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Status', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text(order.status, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                Text(order.vendorName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.vendorColor),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.vendorColor)),
              ],
            ),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _StatusUpdateChips extends StatefulWidget {
  final String currentStatus;
  const _StatusUpdateChips({required this.currentStatus});

  @override
  State<_StatusUpdateChips> createState() => _StatusUpdateChipsState();
}

class _StatusUpdateChipsState extends State<_StatusUpdateChips> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ['Manufacturing', 'Quality Check', 'Dispatched', 'Delivered'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: statuses.map((s) {
        final isSelected = _selected == s;
        return ChoiceChip(
          label: Text(s),
          selected: isSelected,
          onSelected: (_) => setState(() => _selected = s),
          selectedColor: AppColors.vendorColor.withOpacity(0.15),
          checkmarkColor: AppColors.vendorColor,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.vendorColor : null,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }
}
