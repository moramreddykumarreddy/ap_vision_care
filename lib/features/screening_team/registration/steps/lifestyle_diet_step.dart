// lib/features/screening_team/registration/steps/lifestyle_diet_step.dart
import 'package:flutter/material.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _DropdownField = StepDropdownField;

class LifestyleDietStep extends StatelessWidget {
  const LifestyleDietStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Lifestyle & Diet', 'Dietary pattern and nutrition habits', Icons.restaurant_outlined),
          const SizedBox(height: 20),
          _DropdownField('Dietary Pattern', ['Vegetarian', 'Non-Vegetarian', 'Mixed Diet']),
          const SizedBox(height: 14),
          _DropdownField('Fruits Consumption', ['Daily', 'Weekly', 'Rarely', 'Never']),
          const SizedBox(height: 14),
          _DropdownField('Green Leafy Vegetables', ['Daily', 'Weekly', 'Rarely', 'Never']),
          const SizedBox(height: 14),
          _DropdownField('Milk / Dairy Products', ['Daily', 'Weekly', 'Rarely', 'Never']),
          const SizedBox(height: 14),
          _DropdownField('Eggs', ['Daily', 'Weekly', 'Rarely', 'Never']),
          const SizedBox(height: 14),
          _DropdownField('Junk / Fast Food', ['Frequently', 'Occasionally', 'Rarely']),
          const SizedBox(height: 14),
          _DropdownField('Sugary Drinks', ['Frequently', 'Occasionally', 'Rarely']),
          const SizedBox(height: 14),
          _DropdownField('Water Intake', [
            'Less than 2 litres/day',
            '2-4 litres/day',
            'More than 4 litres/day',
          ]),
        ],
      ),
    );
  }
}
