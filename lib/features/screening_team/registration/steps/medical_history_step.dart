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

  static const _conditions = [
    ('Diabetes Mellitus', Icons.water_drop_rounded, Color(0xFFE65100)),
    ('Hypertension', Icons.favorite_rounded, Color(0xFFC62828)),
    ('Thyroid Disorder', Icons.nightlight_rounded, Color(0xFF6A1B9A)),
    ('Heart Disease', Icons.monitor_heart_rounded, Color(0xFFAD1457)),
    ('Kidney Disease', Icons.bloodtype_rounded, Color(0xFF0277BD)),
    ('Stroke / TIA', Icons.psychology_rounded, Color(0xFF37474F)),
    ('Cancer', Icons.healing_rounded, Color(0xFF1B5E20)),
    ('Asthma', Icons.air_rounded, Color(0xFF00695C)),
    ('COPD', Icons.cloud_rounded, Color(0xFF4A148C)),
    ('Anaemia', Icons.science_rounded, Color(0xFF827717)),
    ('Malnutrition', Icons.restaurant_rounded, Color(0xFF558B2F)),
    ('HIV/AIDS', Icons.health_and_safety_rounded, Color(0xFFB71C1C)),
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
