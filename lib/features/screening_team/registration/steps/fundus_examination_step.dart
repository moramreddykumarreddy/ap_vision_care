// lib/features/screening_team/registration/steps/fundus_examination_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class FundusExaminationStep extends StatelessWidget {
  const FundusExaminationStep({super.key});

  static const _sections = [
    (
      title: 'Optic Disc',
      fields: ['Size (C/D Ratio)', 'Shape', 'Margins', 'Color', 'Cup-Disc Ratio'],
    ),
    (
      title: 'Macula',
      fields: ['Macular Reflex', 'Foveal Reflex', 'Macular Oedema', 'ARMD Changes'],
    ),
    (
      title: 'Retinal Vessels',
      fields: ['A:V Ratio', 'Arterial Changes', 'Venous Changes', 'Crossing Changes'],
    ),
    (
      title: 'Diabetic Retinopathy',
      fields: ['DR Grade', 'Microaneurysms', 'Haemorrhages', 'Hard Exudates', 'Neovascularisation'],
    ),
    (
      title: 'Hypertensive Retinopathy',
      fields: ['Keith-Wagener Grade', 'AV Nipping', 'Cotton Wool Spots', 'Papilloedema'],
    ),
    (
      title: 'Retinal Pathology',
      fields: ['Peripheral Retina', 'Retinal Detachment', 'Retinal Tear', 'Other Pathology'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Fundus Examination', 'Dilated fundus examination findings', Icons.biotech_outlined),
          const SizedBox(height: 12),

          // Dilation status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Confirm pupil dilation before examination',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                  ),
                ),
                Switch.adaptive(
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.warning,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fundus photo upload
          Text('Fundus Photographs', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PhotoCapture('Right Eye\n(OD)', AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PhotoCapture('Left Eye\n(OS)', AppColors.accent),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Accordion sections
          ..._sections.map((section) => _FundusAccordion(
            title: section.title,
            fields: section.fields,
          )),
        ],
      ),
    );
  }
}

class _PhotoCapture extends StatelessWidget {
  final String label;
  final Color color;
  const _PhotoCapture(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.04),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundusAccordion extends StatefulWidget {
  final String title;
  final List<String> fields;
  const _FundusAccordion({required this.title, required this.fields});

  @override
  State<_FundusAccordion> createState() => _FundusAccordionState();
}

class _FundusAccordionState extends State<_FundusAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  const Divider(height: 0),
                  const SizedBox(height: 12),
                  ...widget.fields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(field, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Enter...',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.grey300),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
