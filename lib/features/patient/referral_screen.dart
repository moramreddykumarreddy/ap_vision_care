// lib/features/patient/referral_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/pdf_service.dart';
import '../../providers/app_providers.dart';

class PatientReferralScreen extends ConsumerWidget {
  const PatientReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(selectedPatientProvider);
    final allReferrals = ref.watch(referralsProvider);
    final referrals = patient != null
        ? allReferrals.where((r) => r.patientId == patient.id).toList()
        : allReferrals;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
        leading: const AppBarBackButton(),
      ),
      body: referrals.isEmpty
          ? const EmptyState(
              icon: Icons.local_hospital_outlined,
              title: 'No Referrals',
              message: 'You have no hospital referrals at this time',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: referrals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final ref_ = referrals[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_hospital, color: AppColors.error, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ref_.hospital,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    ref_.condition,
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(label: ref_.priority),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 0),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _ReferralStat('Ref ID', ref_.id),
                            ),
                            Expanded(
                              child: _ReferralStat('Date', ref_.date),
                            ),
                            Expanded(
                              child: _ReferralStat('Status', ref_.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Referred by ${ref_.doctorName}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _downloadReferral(context, ref_),
                                icon: const Icon(Icons.download_rounded, size: 15),
                                label: const Text('Download Letter'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _shareReferral(context, ref_),
                                icon: const Icon(Icons.share_rounded, size: 15),
                                label: const Text('Share'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.success,
                                  side: const BorderSide(color: AppColors.success),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
              },
            ),
    );
  }
  Future<void> _downloadReferral(BuildContext context, dynamic ref_) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
      content: Row(children: [
        const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
        const SizedBox(width: 12),
        const Text('Generating referral letter...'),
      ]),
      backgroundColor: AppColors.primaryBlue,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
    try {
      final bytes = await PdfService.generateReferralPdf(
        refId: ref_.id,
        patientName: ref_.patientName,
        patientId: ref_.patientId,
        hospital: ref_.hospital,
        condition: ref_.condition,
        priority: ref_.priority,
        status: ref_.status,
        date: ref_.date,
        doctorName: ref_.doctorName,
      );
      await PdfService.previewPdf(bytes, 'Referral_${ref_.id}');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _shareReferral(BuildContext context, dynamic ref_) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await PdfService.generateReferralPdf(
        refId: ref_.id,
        patientName: ref_.patientName,
        patientId: ref_.patientId,
        hospital: ref_.hospital,
        condition: ref_.condition,
        priority: ref_.priority,
        status: ref_.status,
        date: ref_.date,
        doctorName: ref_.doctorName,
      );
      await PdfService.sharePdf(bytes, 'Referral_${ref_.id}');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}

class _ReferralStat extends StatelessWidget {
  final String label;
  final String value;
  const _ReferralStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500])),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
