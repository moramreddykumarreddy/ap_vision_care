// lib/features/screening_team/registration/steps/existing_spectacles_step.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class ExistingSpectaclesStep extends StatefulWidget {
  const ExistingSpectaclesStep({super.key});

  @override
  State<ExistingSpectaclesStep> createState() => _ExistingSpectaclesStepState();
}

class _ExistingSpectaclesStepState extends State<ExistingSpectaclesStep> {
  bool _hasSpectacles = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Existing Spectacles', 'Current spectacle information', Icons.visibility_outlined),
          const SizedBox(height: 20),

          // Does patient have spectacles?
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_rounded, color: AppColors.primaryBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Does the patient currently wear spectacles?',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Switch.adaptive(
                  value: _hasSpectacles,
                  onChanged: (v) => setState(() => _hasSpectacles = v),
                  activeColor: AppColors.primaryBlue,
                ),
              ],
            ),
          ),

          if (_hasSpectacles) ...[
            const SizedBox(height: 20),

            _DropdownField('Lens Type', [
              'Single Vision',
              'Bifocal',
              'Progressive',
              'Trifocal',
              'Reading Glasses Only',
              'Distance Only',
            ]),

            const SizedBox(height: 14),

            Text(
              'Current Spectacle Power',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            // Right Eye
            _EyePowerCard(
              eye: 'Right Eye (OD)',
              color: AppColors.primaryBlue,
              icon: Icons.remove_red_eye_rounded,
            ),
            const SizedBox(height: 10),

            // Left Eye
            _EyePowerCard(
              eye: 'Left Eye (OS)',
              color: AppColors.accent,
              icon: Icons.remove_red_eye_outlined,
            ),

            const SizedBox(height: 14),
            _FormField(
              'Age of Spectacles',
              hint: 'e.g., 2 years',
              icon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 14),

            // Photo upload of existing spectacles
            Text('Photo of Existing Spectacles', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryBlue.withOpacity(0.04),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, size: 36, color: AppColors.primaryBlue),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to capture photo',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EyePowerCard extends StatelessWidget {
  final String eye;
  final Color color;
  final IconData icon;

  const _EyePowerCard({required this.eye, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(eye, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SPH', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '+1.50',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CYL', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '-0.50',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AXIS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '90',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
