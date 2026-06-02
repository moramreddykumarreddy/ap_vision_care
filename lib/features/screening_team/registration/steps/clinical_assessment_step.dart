// lib/features/screening_team/registration/steps/clinical_assessment_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class ClinicalAssessmentStep extends StatelessWidget {
  const ClinicalAssessmentStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Clinical Assessment', 'Doctor\'s findings and diagnosis', Icons.medical_services_outlined),
          const SizedBox(height: 20),

          // Muscle Function
          Text('Muscle Function', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _DropdownField('Extra-Ocular Muscle Movement', [
            'Full & Free - Both Eyes',
            'Restricted - Right Eye',
            'Restricted - Left Eye',
            'Restricted - Both Eyes',
            'Strabismus (Squint)',
          ]),

          const SizedBox(height: 14),
          _DropdownField('Convergence', ['Normal', 'Reduced', 'Poor', 'Absent']),

          const SizedBox(height: 14),

          // Color Vision
          Text('Color Vision', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _DropdownField('Right Eye', ['Normal', 'Red-Green Defect', 'Blue-Yellow Defect', 'Total Color Blindness'])),
              const SizedBox(width: 14),
              Expanded(child: _DropdownField('Left Eye', ['Normal', 'Red-Green Defect', 'Blue-Yellow Defect', 'Total Color Blindness'])),
            ],
          ),

          const SizedBox(height: 14),

          // Diagnosis
          Text('Diagnosis', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _DropdownField('Primary Diagnosis', [
            'Normal Vision',
            'Myopia (Short-sightedness)',
            'Hyperopia (Long-sightedness)',
            'Astigmatism',
            'Presbyopia',
            'Cataract',
            'Glaucoma',
            'Diabetic Retinopathy',
            'Hypertensive Retinopathy',
            'Age-Related Macular Degeneration',
            'Corneal Ulcer',
            'Pterygium',
            'Dry Eyes',
            'Other',
          ]),
          const SizedBox(height: 10),
          _DropdownField('Secondary Diagnosis (If Any)', [
            'None',
            'Myopia',
            'Astigmatism',
            'Cataract',
            'Glaucoma',
            'Other',
          ]),

          const SizedBox(height: 14),
          _DropdownField('Prognosis', [
            'Good - Full Recovery Expected',
            'Fair - Partial Recovery',
            'Guarded - Monitor Closely',
            'Poor - Irreversible Damage',
          ]),

          const SizedBox(height: 14),
          Text('Treatment Plan', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _CheckboxGroup('Treatment', [
            'Spectacles',
            'Referral to Hospital',
            'Teleconsultation',
            'Medication',
            'Surgery',
            'Lifestyle Modification',
            'No Treatment Required',
          ]),

          const SizedBox(height: 14),
          Text('Medications Prescribed', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'List medications with dosage and duration...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.medication_outlined, size: 20),
              ),
            ),
          ),

          const SizedBox(height: 14),
          _FormField('Follow-up Duration', hint: 'e.g., 3 months', icon: Icons.calendar_month_outlined),

          const SizedBox(height: 14),
          Text('Precautions & Advice', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Precautions, lifestyle advice, and instructions...',
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckboxGroup extends StatefulWidget {
  final String title;
  final List<String> options;
  const _CheckboxGroup(this.title, this.options);

  @override
  State<_CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<_CheckboxGroup> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.options.map((opt) {
        final isSelected = _selected.contains(opt);
        return FilterChip(
          label: Text(opt),
          selected: isSelected,
          onSelected: (v) {
            setState(() {
              if (v) _selected.add(opt);
              else _selected.remove(opt);
            });
          },
          selectedColor: AppColors.primaryBlue.withOpacity(0.12),
          checkmarkColor: AppColors.primaryBlue,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryBlue : null,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }
}
