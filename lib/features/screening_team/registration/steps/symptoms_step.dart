// lib/features/screening_team/registration/steps/symptoms_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_providers.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class SymptomsStep extends ConsumerWidget {
  const SymptomsStep({super.key});

  static const _symptoms = [
    ('Diminished Vision', Icons.visibility_off_rounded),
    ('Redness', Icons.bloodtype_rounded),
    ('Pain in Eye', Icons.sentiment_very_dissatisfied_rounded),
    ('Blurred Vision', Icons.blur_on_rounded),
    ('Photophobia (Light Sensitivity)', Icons.wb_sunny_rounded),
    ('Floaters', Icons.grain_rounded),
    ('Headache', Icons.psychology_alt_rounded),
    ('Watering of Eyes', Icons.water_drop_rounded),
    ('Reading Difficulty', Icons.menu_book_rounded),
    ('Double Vision', Icons.filter_none_rounded),
    ('Eye Discharge', Icons.opacity_rounded),
    ('Itching', Icons.pest_control_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedSymptomsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Symptoms', 'Select all that apply', Icons.sick_outlined),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected.isEmpty
                  ? AppColors.grey100
                  : AppColors.screeningTeamColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selected.isEmpty
                  ? 'No symptoms selected'
                  : '${selected.length} symptom(s) selected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected.isEmpty ? Colors.grey[600] : AppColors.screeningTeamColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
            ),
            itemCount: _symptoms.length,
            itemBuilder: (context, i) {
              final (label, icon) = _symptoms[i];
              final isSelected = selected.contains(label);
              return InkWell(
                onTap: () {
                  final next = Set<String>.from(selected);
                  if (isSelected) {
                    next.remove(label);
                  } else {
                    next.add(label);
                  }
                  ref.read(selectedSymptomsProvider.notifier).state = next;
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.screeningTeamColor.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.screeningTeamColor
                          : theme.colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: isSelected ? AppColors.screeningTeamColor : Colors.grey[400],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.screeningTeamColor : theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          Text('Additional Notes', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Any additional symptoms or observations...',
            ),
          ),
        ],
      ),
    );
  }
}
