// lib/features/screening_team/registration/steps/demographic_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class DemographicStep extends StatelessWidget {
  const DemographicStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Demographic Information', 'Socio-economic background details', Icons.people_outline),
          const SizedBox(height: 20),

          _DropdownField('Marital Status', ['Single', 'Married', 'Widowed', 'Divorced', 'Separated']),
          const SizedBox(height: 14),

          _DropdownField('Education Level', [
            'Illiterate',
            'Primary School (1-5)',
            'Upper Primary (6-8)',
            'Secondary School (9-10)',
            'Higher Secondary (11-12)',
            'Graduate',
            'Post Graduate',
            'Professional Degree',
          ]),
          const SizedBox(height: 14),

          _DropdownField('Occupation', [
            'Agriculture Labour',
            'Farmer (Own Land)',
            'Skilled Labour',
            'Unskilled Labour',
            'Government Employee',
            'Private Employee',
            'Business / Trade',
            'Homemaker',
            'Student',
            'Retired',
            'Unemployed',
            'Other',
          ]),
          const SizedBox(height: 14),

          _DropdownField('Income Category', [
            'BPL (Below Poverty Line)',
            'APL - Low Income (< ₹2 Lakh/year)',
            'APL - Middle Income (₹2-5 Lakh/year)',
            'APL - Higher Income (> ₹5 Lakh/year)',
          ]),
          const SizedBox(height: 14),

          _DropdownField('Social Category', [
            'SC (Scheduled Caste)',
            'ST (Scheduled Tribe)',
            'BC-A',
            'BC-B',
            'BC-C',
            'BC-D',
            'BC-E',
            'EWS (Economically Weaker Section)',
            'OC (Open Category)',
          ]),
          const SizedBox(height: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Area Type', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _AreaTypeSelector(),
            ],
          ),

          const SizedBox(height: 14),

          _DropdownField('Religion', [
            'Hindu',
            'Muslim',
            'Christian',
            'Buddhist',
            'Jain',
            'Sikh',
            'Other',
          ]),

          const SizedBox(height: 14),
          _FormField('Ration Card Number (Optional)', hint: 'AP-XXXX-XXXX', icon: Icons.card_membership_outlined),
        ],
      ),
    );
  }
}

class _AreaTypeSelector extends StatefulWidget {
  @override
  State<_AreaTypeSelector> createState() => _AreaTypeSelectorState();
}

class _AreaTypeSelectorState extends State<_AreaTypeSelector> {
  String _selected = 'Urban';

  @override
  Widget build(BuildContext context) {
    final options = ['Urban', 'Rural', 'Tribal'];
    return Row(
      children: options.map((opt) {
        final isSelected = _selected == opt;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selected = opt),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.screeningTeamColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.screeningTeamColor
                        : AppColors.grey300,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  opt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
