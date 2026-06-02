// lib/features/patient/prescription_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class PrescriptionList extends ConsumerWidget {
  const PrescriptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptions = ref.watch(prescriptionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        leading: const AppBarBackButton(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: prescriptions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final rx = prescriptions[i];
          return Card(
            child: ExpansionTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description, color: AppColors.primaryBlue, size: 22),
              ),
              title: Text(
                rx.diagnosis,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${rx.doctorName} • ${rx.date}',
                style: theme.textTheme.bodySmall,
              ),
              trailing: StatusBadge(label: rx.status),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      // Vision Table
                      Text(
                        'Prescription Details',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          _tableHeader(['Eye', 'SPH', 'CYL', 'AXIS'], theme),
                          _tableRow(['Right Eye (OD)', rx.rightEyeSph, rx.rightEyeCyl, rx.rightEyeAxis], theme),
                          _tableRow(['Left Eye (OS)', rx.leftEyeSph, rx.leftEyeCyl, rx.leftEyeAxis], theme),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text('Download PDF'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share, size: 16),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
        },
      ),
    );
  }

  TableRow _tableHeader(List<String> cells, ThemeData theme) {
    return TableRow(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.06),
      ),
      children: cells.map((c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          c,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }

  TableRow _tableRow(List<String> cells, ThemeData theme) {
    return TableRow(
      children: cells.mapIndexed((i, c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          c,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}
