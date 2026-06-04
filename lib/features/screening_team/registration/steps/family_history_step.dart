// lib/features/screening_team/registration/steps/family_history_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_providers.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class FamilyHistoryStep extends ConsumerWidget {
  const FamilyHistoryStep({super.key});

  static const _conditions = [
    ('Diabetes', Icons.water_drop_rounded),
    ('Hypertension', Icons.favorite_rounded),
    ('Blindness', Icons.visibility_off_rounded),
    ('Glaucoma', Icons.remove_red_eye_rounded),
    ('Cataract', Icons.wb_cloudy_rounded),
    ('Genetic Eye Disorders', Icons.biotech_rounded),
    ('Retinal Disease', Icons.remove_red_eye_outlined),
    ('Colour Blindness', Icons.palette_rounded),
    ('Corneal Disease', Icons.lens_blur_rounded),
    ('Cancer', Icons.healing_rounded),
    ('Mental Illness', Icons.psychology_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedFamilyHistoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Family History', 'Conditions in blood relatives', Icons.family_restroom_outlined),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemCount: _conditions.length,
            itemBuilder: (context, i) {
              final (label, icon) = _conditions[i];
              final isSelected = selected.contains(label);
              return InkWell(
                onTap: () {
                  final next = Set<String>.from(selected);
                  if (isSelected) next.remove(label);
                  else next.add(label);
                  ref.read(selectedFamilyHistoryProvider.notifier).state = next;
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.warning.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: isSelected ? AppColors.warning : theme.colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: isSelected ? AppColors.warning : Colors.grey[400],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.warning : null,
                          ),
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
          Text('Family Notes', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Additional family history details...',
            ),
          ),
        ],
      ),
    );
  }
}
