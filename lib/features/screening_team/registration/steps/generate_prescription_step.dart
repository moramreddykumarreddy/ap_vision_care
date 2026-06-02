// lib/features/screening_team/registration/steps/generate_prescription_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class GeneratePrescriptionStep extends StatelessWidget {
  const GeneratePrescriptionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
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
                    Text('Review before generating', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Prescription document preview
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
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A3A6B), Color(0xFF2952A3)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(Icons.visibility, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AP Vision Program',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                Text(
                                  'Government of Andhra Pradesh',
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('RX', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rx ID: RX-2024-003', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                          Text('Date: 22 Mar 2024', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Patient info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _RxRow('Patient', 'Ravi Kumar Reddy (45y, Male)'),
                      _RxRow('ABHA No.', '14-3456-7890-1234'),
                      _RxRow('District', 'Krishna, Andhra Pradesh'),
                      _RxRow('Camp', 'Eye Screening Camp - Nuzvid'),
                      const Divider(height: 20),
                      _RxRow('Diagnosis', 'Myopia with Astigmatism'),

                      const SizedBox(height: 12),
                      // Power table
                      Table(
                        border: TableBorder.all(color: AppColors.grey200, borderRadius: BorderRadius.circular(8)),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(1.5),
                        },
                        children: [
                          _rxTableHeader(['Eye', 'SPH', 'CYL', 'AXIS', 'V/A']),
                          _rxTableRow(['Right (OD)', '-2.50', '-0.75', '180°', '6/9']),
                          _rxTableRow(['Left (OS)', '-2.25', '-0.50', '175°', '6/9']),
                        ],
                      ),

                      const Divider(height: 20),
                      _RxRow('Lens Type', 'Anti-Reflective Single Vision'),
                      _RxRow('Frame', 'Full Rim - Medium'),
                      _RxRow('Follow-up', '6 months'),
                    ],
                  ),
                ),

                // Doctor signature
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              child: const Center(
                                child: Text(
                                  'Dr. Venkata Rao',
                                  style: TextStyle(
                                    fontFamily: 'cursive',
                                    fontSize: 20,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            const Text('Dr. Venkata Rao', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            const Text('MBBS, MS (Ophthalmology)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            const Text('Reg. No: AP-MED-12345', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.06),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.verified, color: AppColors.primaryBlue, size: 28),
                          ),
                          const SizedBox(height: 4),
                          const Text('Digitally\nSigned', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'This prescription is valid for 6 months from the date of issue.\nFor queries: helpdesk@apvisioncare.gov.in | 1800-XXX-XXXX',
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 20),

          // Action buttons
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient registration completed and prescription generated!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
              context.go('/screening/dashboard');
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Submit & Generate Prescription'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.screeningTeamColor,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading prescription PDF...'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Download PDF Preview'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription shared via SMS and WhatsApp!'),
                  backgroundColor: AppColors.primaryBlue,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.share_rounded, size: 18),
            label: const Text('Share Prescription'),
          ),
        ],
      ),
    );
  }

  TableRow _rxTableHeader(List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.06)),
      children: cells.map((c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(c, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryBlue), textAlign: TextAlign.center),
      )).toList(),
    );
  }

  TableRow _rxTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(c, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      )).toList(),
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
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
