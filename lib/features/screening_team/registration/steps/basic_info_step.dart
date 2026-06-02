// lib/features/screening_team/registration/steps/basic_info_step.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import 'shared_step_widgets.dart';

class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Basic Information', 'Enter patient\'s personal details', Icons.person_outline),
          const SizedBox(height: 20),

          // Photo Upload
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.screeningTeamColor.withOpacity(0.1),
                    border: Border.all(color: AppColors.screeningTeamColor.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.person, size: 50, color: AppColors.screeningTeamColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColors.screeningTeamColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap to upload photo',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 24),

          _FormField('Full Name (English)', hint: 'Ravi Kumar Reddy', icon: Icons.badge_outlined),
          const SizedBox(height: 14),
          _FormField('Full Name (Telugu)', hint: 'రవి కుమార్ రెడ్డి', icon: Icons.translate),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _FormField(
                  'Age',
                  hint: '45',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.wc_outlined, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      hint: const Text('Select'),
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          _FormField(
            'Mobile Number',
            hint: '9876543210',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 14),
          _FormField('ABHA Number (Optional)', hint: '14-XXXX-XXXX-XXXX', icon: Icons.qr_code_outlined),
          const SizedBox(height: 14),
          _FormField('Address', hint: 'H.No, Street, Area', icon: Icons.home_outlined, maxLines: 2),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(child: _DropdownField('District', ['Krishna', 'Guntur', 'East Godavari', 'West Godavari', 'Visakhapatnam'])),
              const SizedBox(width: 14),
              Expanded(child: _FormField('Mandal', hint: 'Vijayawada', icon: Icons.location_on_outlined)),
            ],
          ),
          const SizedBox(height: 14),
          _FormField('Village / Habitation', hint: 'Village name', icon: Icons.cottage_outlined),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;
