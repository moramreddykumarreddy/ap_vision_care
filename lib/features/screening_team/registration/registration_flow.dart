// lib/features/screening_team/registration/registration_flow.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/app_providers.dart';
import 'steps/basic_info_step.dart';
import 'steps/demographic_step.dart';
import 'steps/symptoms_step.dart';
import 'steps/medical_history_step.dart';
import 'steps/family_history_step.dart';
import 'steps/lifestyle_diet_step.dart';
import 'steps/risk_profile_step.dart';
import 'steps/population_health_step.dart';
import 'steps/existing_spectacles_step.dart';
import 'steps/vision_examination_step.dart';
import 'steps/refraction_step.dart';
import 'steps/clinical_assessment_step.dart';
import 'steps/fundus_examination_step.dart';
import 'steps/decision_engine_step.dart';
import 'steps/generate_prescription_step.dart';

class RegistrationFlow extends ConsumerStatefulWidget {
  const RegistrationFlow({super.key});

  @override
  ConsumerState<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends ConsumerState<RegistrationFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final List<_StepInfo> _steps = [
    _StepInfo('Basic Info', Icons.person_outline),
    _StepInfo('Demographics', Icons.people_outline),
    _StepInfo('Symptoms', Icons.sick_outlined),
    _StepInfo('Medical Hx', Icons.medical_information_outlined),
    _StepInfo('Family Hx', Icons.family_restroom_outlined),
    _StepInfo('Lifestyle', Icons.restaurant_outlined),
    _StepInfo('Risk Profile', Icons.warning_amber_outlined),
    _StepInfo('Pop. Health', Icons.health_and_safety_outlined),
    _StepInfo('Spectacles', Icons.visibility_outlined),
    _StepInfo('Vision Exam', Icons.remove_red_eye_outlined),
    _StepInfo('Refraction', Icons.tune_outlined),
    _StepInfo('Clinical', Icons.medical_services_outlined),
    _StepInfo('Fundus', Icons.biotech_outlined),
    _StepInfo('Decision', Icons.analytics_outlined),
    _StepInfo('Prescription', Icons.description_outlined),
  ];

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prev() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _prev();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('New Patient Registration'),
          backgroundColor: AppColors.screeningTeamColor,
          leading: IconButton(
            icon: Icon(_currentStep > 0 ? Icons.arrow_back : Icons.close),
            onPressed: () {
              if (_currentStep > 0) {
                _prev();
              } else {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/screening/dashboard');
                }
              }
            },
          ),
        ),
        body: Column(
          children: [
            // Step Progress Header
            _StepProgressHeader(
              steps: _steps,
              currentStep: _currentStep,
            ),
  
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  BasicInfoStep(),
                  DemographicStep(),
                  SymptomsStep(),
                  MedicalHistoryStep(),
                  FamilyHistoryStep(),
                  LifestyleDietStep(),
                  RiskProfileStep(),
                  PopulationHealthStep(),
                  ExistingSpectaclesStep(),
                  VisionExaminationStep(),
                  RefractionStep(),
                  ClinicalAssessmentStep(),
                  FundusExaminationStep(),
                  DecisionEngineStep(),
                  GeneratePrescriptionStep(),
                ],
              ),
            ),
  
            // Navigation buttons
            _StepNavigation(
              currentStep: _currentStep,
              totalSteps: _steps.length,
              onPrev: _prev,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepInfo {
  final String label;
  final IconData icon;
  const _StepInfo(this.label, this.icon);
}

class _StepProgressHeader extends StatelessWidget {
  final List<_StepInfo> steps;
  final int currentStep;

  const _StepProgressHeader({required this.steps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of ${steps.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.screeningTeamColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                steps[currentStep].label,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Segmented progress
          Row(
            children: List.generate(steps.length, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= currentStep
                        ? AppColors.screeningTeamColor
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _StepNavigation({
    required this.currentStep,
    required this.totalSteps,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentStep == totalSteps - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrev,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text(
                  'Previous',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: Icon(isLast ? Icons.check : Icons.arrow_forward, size: 16),
              label: Text(
                isLast ? 'Submit for Approval' : 'Next',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLast ? AppColors.screeningTeamColor : AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
