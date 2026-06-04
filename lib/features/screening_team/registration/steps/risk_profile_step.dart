// lib/features/screening_team/registration/steps/risk_profile_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_providers.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _DropdownField = StepDropdownField;

class RiskProfileStep extends ConsumerWidget {
  const RiskProfileStep({super.key});

  static const _exposures = [
    'Sunlight Exposure >6 hours/day',
    'Dust Exposure',
    'Chemical Exposure',
    'Welding Exposure',
    'Screen Exposure >6 hours/day',
  ];

  static const _devices = ['Mobile', 'Tablet', 'Laptop', 'Desktop', 'Television'];

  static const _deviceSymptoms = ['Eye Strain', 'Headache', 'Dry Eyes', 'Blurred Vision'];

  static const _addictions = [
    ('Tobacco', ['Never', 'Current User', 'Former User']),
    ('Smoking', ['Never', 'Current', 'Former']),
    ('Alcohol', ['Never', 'Occasional', 'Regular']),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final exposures = ref.watch(selectedOccupationalExposureProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Risk Profile', 'Occupational, digital device & addiction habits', Icons.warning_amber_outlined),
          const SizedBox(height: 20),

          Text('Occupation Category', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _DropdownField('Occupation', [
            'Farmer', 'Fisherman', 'Labourer', 'Factory Worker', 'Student',
            'Driver', 'IT Employee', 'Homemaker', 'Government Employee', 'Retired',
          ]),
          const SizedBox(height: 16),

          Text('Occupational Exposure', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ..._exposures.map((e) => _CheckTile(
                label: e,
                selected: exposures.contains(e),
                onTap: () {
                  final next = Set<String>.from(exposures);
                  if (next.contains(e)) {
                    next.remove(e);
                  } else {
                    next.add(e);
                  }
                  ref.read(selectedOccupationalExposureProvider.notifier).state = next;
                },
              )),

          const SizedBox(height: 20),
          _DropdownField('Daily Screen Time', ['<2 hours', '2-4 hours', '4-8 hours', '8+ hours']),
          const SizedBox(height: 14),
          Text('Devices Used', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _devices.map((d) => Chip(label: Text(d, style: const TextStyle(fontSize: 12)))).toList(),
          ),
          const SizedBox(height: 14),
          Text('Digital Eye Strain Symptoms', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _deviceSymptoms
                .map((s) => FilterChip(label: Text(s), selected: false, onSelected: (_) {}))
                .toList(),
          ),

          const SizedBox(height: 20),
          Text('Addiction & Habits', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ..._addictions.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DropdownField(a.$1, a.$2),
              )),
          _DropdownField('Gutka / Pan Masala', ['No', 'Yes']),
        ],
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CheckTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.screeningTeamColor.withOpacity(0.08) : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.screeningTeamColor : Colors.grey.shade300,
        ),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: (_) => onTap(),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
