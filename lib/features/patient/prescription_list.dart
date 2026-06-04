// lib/features/patient/prescription_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/pdf_service.dart';
import '../../providers/app_providers.dart';

class PrescriptionList extends ConsumerWidget {
  const PrescriptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(selectedPatientProvider);
    final allPrescriptions = ref.watch(prescriptionsProvider);
    final prescriptions = patient != null
        ? allPrescriptions.where((p) => p.patientId == patient.id).toList()
        : allPrescriptions;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        leading: const AppBarBackButton(),
      ),
      body: prescriptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('No prescriptions found', style: theme.textTheme.titleMedium),
                ],
              ),
            )
          : ListView.separated(
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
                                  child: _ActionButton(
                                    icon: Icons.download_rounded,
                                    label: 'Download PDF',
                                    color: AppColors.accent,
                                    onTap: () => _downloadPrescription(context, rx, patient),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ActionButton(
                                    icon: Icons.share_rounded,
                                    label: 'Share',
                                    color: AppColors.success,
                                    outlined: true,
                                    onTap: () => _sharePrescription(context, rx, patient),
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

  Future<void> _downloadPrescription(BuildContext context, dynamic rx, dynamic patient) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      _showLoadingSnackBar(messenger, 'Generating prescription PDF...');
      final bytes = await PdfService.generatePrescriptionPdf(
        rxId: rx.id,
        patientName: rx.patientName,
        patientId: rx.patientId,
        abhaNumber: patient?.abhaNumber ?? 'N/A',
        doctorName: rx.doctorName,
        date: rx.date,
        diagnosis: rx.diagnosis,
        rightSph: rx.rightEyeSph,
        rightCyl: rx.rightEyeCyl,
        rightAxis: rx.rightEyeAxis,
        leftSph: rx.leftEyeSph,
        leftCyl: rx.leftEyeCyl,
        leftAxis: rx.leftEyeAxis,
        status: rx.status,
        district: patient?.district ?? '',
      );
      await PdfService.previewPdf(bytes, 'Prescription_${rx.id}');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _sharePrescription(BuildContext context, dynamic rx, dynamic patient) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      _showLoadingSnackBar(messenger, 'Preparing to share...');
      final bytes = await PdfService.generatePrescriptionPdf(
        rxId: rx.id,
        patientName: rx.patientName,
        patientId: rx.patientId,
        abhaNumber: patient?.abhaNumber ?? 'N/A',
        doctorName: rx.doctorName,
        date: rx.date,
        diagnosis: rx.diagnosis,
        rightSph: rx.rightEyeSph,
        rightCyl: rx.rightEyeCyl,
        rightAxis: rx.rightEyeAxis,
        leftSph: rx.leftEyeSph,
        leftCyl: rx.leftEyeCyl,
        leftAxis: rx.leftEyeAxis,
        status: rx.status,
        district: patient?.district ?? '',
      );
      await PdfService.sharePdf(bytes, 'Prescription_${rx.id}');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _showLoadingSnackBar(ScaffoldMessengerState messenger, String msg) {
    messenger.showSnackBar(SnackBar(
      content: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(msg),
        ],
      ),
      backgroundColor: AppColors.primaryBlue,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }

  TableRow _tableHeader(List<String> cells, ThemeData theme) {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.06)),
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

// ─── Reusable Action Button ───────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.outlined) {
      return OutlinedButton.icon(
        onPressed: _loading ? null : _handle,
        icon: _loading
            ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: widget.color))
            : Icon(widget.icon, size: 16),
        label: Text(widget.label),
        style: OutlinedButton.styleFrom(foregroundColor: widget.color, side: BorderSide(color: widget.color)),
      );
    }
    return ElevatedButton.icon(
      onPressed: _loading ? null : _handle,
      icon: _loading
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Icon(widget.icon, size: 16),
      label: Text(widget.label),
      style: ElevatedButton.styleFrom(backgroundColor: widget.color, foregroundColor: Colors.white),
    );
  }

  Future<void> _handle() async {
    setState(() => _loading = true);
    try {
      await Future.microtask(widget.onTap);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}
