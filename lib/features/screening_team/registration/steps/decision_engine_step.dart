// lib/features/screening_team/registration/steps/decision_engine_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_providers.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;

class DecisionEngineStep extends ConsumerWidget {
  const DecisionEngineStep({super.key});

  static const _outcomes = [
    (
      DecisionOutcome.normal,
      'Case A: Vision Normal',
      'No spectacles required.',
      Icons.check_circle_rounded,
      AppColors.success,
    ),
    (
      DecisionOutcome.existingGlassesAdequate,
      'Case B: Existing Glasses Adequate',
      'Continue existing spectacles.',
      Icons.visibility_rounded,
      AppColors.info,
    ),
    (
      DecisionOutcome.spectaclesRequired,
      'Case C: New Spectacles Required',
      'Generate order for spectacles.',
      Icons.visibility_rounded,
      AppColors.primaryBlue,
    ),
    (
      DecisionOutcome.referralRequired,
      'Case D: Clinical Issue Found',
      'Referral required.',
      Icons.local_hospital_rounded,
      AppColors.warning,
    ),
    (
      DecisionOutcome.teleconsultationRequired,
      'Case E: Specialist Review Required',
      'Teleconsultation required.',
      Icons.video_call_rounded,
      AppColors.teleDocColor,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(decisionOutcomeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Decision Engine', 'AI-powered clinical decision support (Cases A–E)', Icons.analytics_outlined),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A3A6B), Color(0xFF2952A3)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                SizedBox(height: 12),
                Text(
                  'Clinical Decision Engine',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6),
                Text(
                  'Select the appropriate outcome based on examination',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Text('Decision Outcomes', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ..._outcomes.map((o) {
            final (outcome, title, desc, icon, color) = o;
            final isSelected = selected == outcome;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OutcomeCard(
                title: title,
                description: desc,
                icon: icon,
                color: color,
                isSelected: isSelected,
                onTap: () => ref.read(decisionOutcomeProvider.notifier).state = outcome,
              ),
            );
          }),
          const SizedBox(height: 16),
          Text('AI Risk Scores', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          _RiskScore('Cataract Risk', 0.34, AppColors.warning),
          const SizedBox(height: 10),
          _RiskScore('Glaucoma Risk', 0.08, AppColors.success),
          const SizedBox(height: 10),
          _RiskScore('Diabetic Retinopathy', 0.56, AppColors.error),
        ],
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _OutcomeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: isSelected ? color : null)),
                  Text(description, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}

class _RiskScore extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _RiskScore(this.label, this.score, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (score * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            Text('$pct%', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
