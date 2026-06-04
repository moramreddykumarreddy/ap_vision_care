// lib/features/screening_team/registration/steps/medical_history_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_providers.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class MedicalHistoryStep extends ConsumerWidget {
  const MedicalHistoryStep({super.key});

  static final _conditions = [
    ('Diabetes Mellitus', Icons.water_drop_rounded, AppColors.chartColorAt(0)),
    ('Hypertension', Icons.favorite_rounded, AppColors.chartColorAt(1)),
    ('Thyroid Disorder', Icons.nightlight_rounded, AppColors.chartColorAt(2)),
    ('Heart Disease', Icons.monitor_heart_rounded, AppColors.chartColorAt(3)),
    ('Kidney Disease', Icons.bloodtype_rounded, AppColors.chartColorAt(4)),
    ('Stroke / TIA', Icons.psychology_rounded, AppColors.chartColorAt(5)),
    ('Cancer', Icons.healing_rounded, AppColors.chartColorAt(0)),
    ('Asthma', Icons.air_rounded, AppColors.chartColorAt(1)),
    ('COPD', Icons.cloud_rounded, AppColors.chartColorAt(2)),
    ('Anaemia', Icons.science_rounded, AppColors.chartColorAt(3)),
    ('Malnutrition', Icons.restaurant_rounded, AppColors.chartColorAt(4)),
    ('HIV/AIDS', Icons.health_and_safety_rounded, AppColors.chartColorAt(5)),
  ];

  static final _ocularConditions = [
    ('Refractive Error', Icons.visibility_outlined, AppColors.chartColorAt(0)),
    ('Cataract', Icons.lens_outlined, AppColors.chartColorAt(1)),
    ('Glaucoma', Icons.remove_red_eye_outlined, AppColors.chartColorAt(2)),
    ('Ocular Trauma', Icons.healing_outlined, AppColors.chartColorAt(3)),
    ('Eye Surgery', Icons.medical_services_outlined, AppColors.chartColorAt(4)),
    ('Contact Lens Use', Icons.circle_outlined, AppColors.chartColorAt(5)),
    ('Prosthesis / Conformer Use', Icons.accessibility_new_outlined, AppColors.chartColorAt(0)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedMedicalHistoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Medical History', 'Select all existing conditions', Icons.medical_information_outlined),
          const SizedBox(height: 16),

          ...List.generate(_conditions.length, (i) {
            final (label, icon, color) = _conditions[i];
            final isSelected = selected.contains(label);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.06) : theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected ? color.withOpacity(0.4) : theme.colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  final next = Set<String>.from(selected);
                  if (isSelected) next.remove(label);
                  else next.add(label);
                  ref.read(selectedMedicalHistoryProvider.notifier).state = next;
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) {
                          final next = Set<String>.from(selected);
                          if (isSelected) next.remove(label);
                          else next.add(label);
                          ref.read(selectedMedicalHistoryProvider.notifier).state = next;
                        },
                        activeColor: color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          Text('Disease Duration & Treatment', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _DropdownField('Duration of Disease', ['Less than 1 year', '1-5 years', 'More than 5 years', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Current Treatment', ['Regular', 'Irregular', 'Not Taking Treatment', 'Not Applicable']),

          const SizedBox(height: 20),
          Text('Ocular & Eye History', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...List.generate(_ocularConditions.length, (i) {
            final (label, icon, color) = _ocularConditions[i];
            final isSelected = ref.watch(selectedOcularHistoryProvider).contains(label);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.06) : theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected ? color.withOpacity(0.4) : theme.colorScheme.outline.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: isSelected,
                onChanged: (_) {
                  final next = Set<String>.from(ref.read(selectedOcularHistoryProvider));
                  if (isSelected) {
                    next.remove(label);
                  } else {
                    next.add(label);
                  }
                  ref.read(selectedOcularHistoryProvider.notifier).state = next;
                },
                title: Text(label, style: const TextStyle(fontSize: 13)),
                secondary: Icon(icon, color: color, size: 20),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          }),

          // Additional medications
          const SizedBox(height: 8),
          Text('Current Medications', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'List current medications if any...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.medication_outlined, size: 20),
              ),
            ),
          ),

          const SizedBox(height: 14),
          Text('Known Allergies', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Known drug / food allergies...',
              prefixIcon: Icon(Icons.warning_amber_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
