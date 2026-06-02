// lib/features/screening_team/registration/steps/refraction_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class RefractionStep extends StatelessWidget {
  const RefractionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Refraction', 'Record spectacle power prescription', Icons.tune_outlined),
          const SizedBox(height: 20),

          // Distance Vision
          _RefractionSection(
            title: 'Distance Vision',
            color: AppColors.primaryBlue,
            icon: Icons.remove_red_eye_rounded,
            rows: const ['Right Eye (OD)', 'Left Eye (OS)'],
          ),

          const SizedBox(height: 20),

          // Near Vision
          _RefractionSection(
            title: 'Near Vision (Add)',
            color: AppColors.accent,
            icon: Icons.menu_book_rounded,
            rows: const ['Right Eye (OD)', 'Left Eye (OS)'],
            showAdd: true,
          ),

          const SizedBox(height: 16),
          _DropdownField('Correction Type', [
            'Single Vision - Distance',
            'Single Vision - Near',
            'Bifocal',
            'Progressive',
            'No Correction Required',
          ]),

          const SizedBox(height: 14),
          Text('Remarks', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Additional refraction notes...',
            ),
          ),
        ],
      ),
    );
  }
}

class _RefractionSection extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> rows;
  final bool showAdd;

  const _RefractionSection({
    required this.title,
    required this.color,
    required this.icon,
    required this.rows,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ),
          // Column headers
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                const SizedBox(width: 90),
                ..._columnLabel('SPH'),
                ..._columnLabel('CYL'),
                ..._columnLabel('AXIS'),
                ..._columnLabel('V/A'),
                if (showAdd) ..._columnLabel('ADD'),
              ].expand((e) => [e]).toList(),
            ),
          ),
          // Data rows
          ...rows.map((row) {
            final isRight = row.contains('Right');
            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      row,
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ..._dataField('+1.50'),
                  ..._dataField('-0.50'),
                  ..._dataField('90'),
                  ..._dataField('6/9'),
                  if (showAdd) ..._dataField('+2.00'),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Widget> _columnLabel(String label) {
    return [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  List<Widget> _dataField(String hint) {
    return [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
            ),
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }
}
