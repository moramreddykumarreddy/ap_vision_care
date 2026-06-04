// lib/features/screening_team/registration/steps/population_health_step.dart
import 'package:flutter/material.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _DropdownField = StepDropdownField;
typedef _FormField = StepFormField;

class PopulationHealthStep extends StatelessWidget {
  const PopulationHealthStep({super.key});

  static const _qolItems = [
    'Difficulty Reading',
    'Difficulty Driving',
    'Difficulty Working',
    'Difficulty Recognizing Faces',
    'Difficulty Walking at Night',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle(
            'Population Health',
            'Women\'s, elderly, child, access & quality of life',
            Icons.health_and_safety_outlined,
          ),
          const SizedBox(height: 20),

          Text('Women\'s Health (if applicable)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _DropdownField('Pregnancy Status', ['Pregnant', 'Not Pregnant', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Lactating Mother', ['Yes', 'No', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Anaemia History', ['Yes', 'No', 'Not Applicable']),

          const SizedBox(height: 20),
          Text('Elderly Health (Age >60)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _DropdownField('History of Falls', ['Yes', 'No', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Mobility Issues', ['Yes', 'No', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Memory Problems', ['Yes', 'No', 'Not Applicable']),

          const SizedBox(height: 20),
          Text('Child-Specific (Age <18)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _FormField('School Name', hint: 'ZP High School', icon: Icons.school_outlined),
          const SizedBox(height: 14),
          _DropdownField('Class', ['1-5', '6-8', '9-10', '11-12']),
          const SizedBox(height: 14),
          _DropdownField('Academic Performance', ['Good', 'Average', 'Poor', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Blackboard Visibility Issues', ['Yes', 'No', 'Not Applicable']),
          const SizedBox(height: 14),
          _DropdownField('Reading Difficulties', ['Yes', 'No', 'Not Applicable']),

          const SizedBox(height: 20),
          Text('Healthcare Access', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _DropdownField('Last Eye Checkup', ['Never', 'Within 1 Year', '1-3 Years', 'More than 3 Years']),
          const SizedBox(height: 14),
          _DropdownField('Distance to Nearest Hospital', ['<5 km', '5-10 km', '>10 km']),
          const SizedBox(height: 14),
          _DropdownField('Health Insurance', [
            'Ayushman Bharat',
            'State Scheme',
            'Private Insurance',
            'None',
          ]),

          const SizedBox(height: 20),
          Text('Quality of Life (due to vision issues)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ..._qolItems.map((q) => CheckboxListTile(
                value: false,
                onChanged: (_) {},
                title: Text(q, style: const TextStyle(fontSize: 13)),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )),
        ],
      ),
    );
  }
}
