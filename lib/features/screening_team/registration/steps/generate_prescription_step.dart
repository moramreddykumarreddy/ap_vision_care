// lib/features/screening_team/registration/steps/generate_prescription_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';

class GeneratePrescriptionStep extends ConsumerWidget {
  const GeneratePrescriptionStep({super.key});

  String _outcomeLabel(DecisionOutcome outcome) {
    return switch (outcome) {
      DecisionOutcome.normal => 'Case A: No spectacles required',
      DecisionOutcome.existingGlassesAdequate => 'Case B: Continue existing spectacles',
      DecisionOutcome.spectaclesRequired => 'Case C: New spectacles — pending nodal approval',
      DecisionOutcome.referralRequired => 'Case D: Referral initiated — pending nodal approval',
      DecisionOutcome.teleconsultationRequired => 'Case E: Teleconsultation scheduled',
    };
  }

  void _submit(BuildContext context, WidgetRef ref) {
    final outcome = ref.read(decisionOutcomeProvider);
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (outcome == DecisionOutcome.spectaclesRequired) {
      final rx = PrescriptionModel(
        id: 'RX-${now.millisecondsSinceEpoch}',
        patientId: 'P-NEW',
        patientName: 'New Camp Patient',
        date: date,
        doctorName: 'Dr. Screening Team',
        diagnosis: 'Refractive Error',
        rightEyeSph: '-1.50',
        rightEyeCyl: '-0.50',
        rightEyeAxis: '180',
        leftEyeSph: '-1.25',
        leftEyeCyl: '-0.25',
        leftEyeAxis: '175',
        status: 'Pending Approval',
        spectacleStatus: SpectacleStatus.prescriptionApproved,
      );
      ref.read(prescriptionsProvider.notifier).state = [
        rx,
        ...ref.read(prescriptionsProvider),
      ];
    }

    if (outcome == DecisionOutcome.referralRequired) {
      final referral = ReferralModel(
        id: 'REF-${now.millisecondsSinceEpoch}',
        patientName: 'New Camp Patient',
        patientId: 'P-NEW',
        hospital: 'District Referral Hospital',
        condition: 'Clinical issue requiring specialist evaluation',
        priority: 'High',
        status: 'Pending',
        date: date,
        doctorName: 'Dr. Screening Team',
      );
      ref.read(referralsProvider.notifier).state = [
        referral,
        ...ref.read(referralsProvider),
      ];
    }

    if (outcome == DecisionOutcome.teleconsultationRequired) {
      final tele = TeleconsultationModel(
        id: 'TC-${now.millisecondsSinceEpoch}',
        patientName: 'New Camp Patient',
        patientId: 'P-NEW',
        doctorName: 'Dr. Tele Specialist',
        scheduledTime: now.add(const Duration(hours: 2)).toIso8601String(),
        status: 'Scheduled',
        condition: 'Specialist review required',
        duration: 30,
      );
      ref.read(teleconsultationsProvider.notifier).state = [
        tele,
        ...ref.read(teleconsultationsProvider),
      ];
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitted for nodal approval. ${_outcomeLabel(outcome)}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go('/screening/dashboard');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final outcome = ref.watch(decisionOutcomeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.screeningTeamColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_outlined, color: AppColors.screeningTeamColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prescription Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text('Review before submitting to nodal officer', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _outcomeLabel(outcome),
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF1A3A6B), Color(0xFF2952A3)]),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('AP Vision Program Prescription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _RxRow('Patient', 'Camp Registration Patient'),
                      _RxRow('Camp', 'Active Screening Camp'),
                      Divider(height: 20),
                      _RxRow('Decision', 'See outcome above'),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _submit(context, ref),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Submit for Nodal Approval'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.screeningTeamColor,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading prescription PDF...'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Download PDF Preview'),
          ),
        ],
      ),
    );
  }
}

class _RxRow extends StatelessWidget {
  final String label;
  final String value;
  const _RxRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
