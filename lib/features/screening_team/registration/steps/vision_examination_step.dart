// lib/features/screening_team/registration/steps/vision_examination_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class VisionExaminationStep extends StatelessWidget {
  const VisionExaminationStep({super.key});

  static const _rows = [
    ('UCDVA', 'Unaided Distance Visual Acuity'),
    ('BCDVA', 'Best Corrected Distance VA'),
    ('PH', 'Pinhole Visual Acuity'),
    ('UCNVA', 'Unaided Near Visual Acuity'),
    ('BCNVA', 'Best Corrected Near VA'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Vision Examination', 'Record visual acuity measurements', Icons.remove_red_eye_outlined),
          const SizedBox(height: 20),

          // Legend
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.info.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Record in Snellen notation (e.g., 6/6, 6/9, 6/12, 6/18, 6/24, 6/36, 6/60, CF, HM, PL, NPL)',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Vision Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.08),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Measurement', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryBlue)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Right Eye\n(OD)', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryBlue), textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Left Eye\n(OS)', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryBlue), textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  // Data rows
                  ..._rows.map((row) {
                    final (abbrev, full) = row;
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2))),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(abbrev, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                              Text(full, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500], fontSize: 10)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            hint: const Text('Select', style: TextStyle(fontSize: 12)),
                            items: ['6/6', '6/9', '6/12', '6/18', '6/24', '6/36', '6/60', 'CF', 'HM', 'PL', 'NPL']
                                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 13))))
                                .toList(),
                            onChanged: (_) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            hint: const Text('Select', style: TextStyle(fontSize: 12)),
                            items: ['6/6', '6/9', '6/12', '6/18', '6/24', '6/36', '6/60', 'CF', 'HM', 'PL', 'NPL']
                                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 13))))
                                .toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // IOP
          Text('Intraocular Pressure (IOP)', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _FormField('Right Eye IOP', hint: 'e.g., 14 mmHg', icon: Icons.compress_rounded),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _FormField('Left Eye IOP', hint: 'e.g., 16 mmHg', icon: Icons.compress_rounded),
              ),
            ],
          ),

          const SizedBox(height: 14),
          _DropdownField('Measurement Method', ['Applanation Tonometry', 'Non-Contact Tonometry', 'Digital Palpation']),
        ],
      ),
    );
  }
}
