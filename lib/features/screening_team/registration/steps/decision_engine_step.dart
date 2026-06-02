// lib/features/screening_team/registration/steps/decision_engine_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'basic_info_step.dart';
import 'shared_step_widgets.dart';

typedef _StepTitle = StepTitle;
typedef _FormField = StepFormField;
typedef _DropdownField = StepDropdownField;

class DecisionEngineStep extends StatelessWidget {
  const DecisionEngineStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle('Decision Engine', 'AI-Powered clinical decision support', Icons.analytics_outlined),
          const SizedBox(height: 20),

          // AI Processing Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3A6B), Color(0xFF2952A3)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                const Text(
                  'Clinical Decision Engine',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Analyzing patient data using AI algorithms',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          Text('Decision Outcomes', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),

          // Outcomes
          _OutcomeCard(
            title: 'Normal',
            description: 'No significant refractive error or pathology detected.',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            isSelected: false,
          ),
          const SizedBox(height: 10),
          _OutcomeCard(
            title: 'Spectacles Required',
            description: 'Significant refractive error detected. Prescription generated.',
            icon: Icons.visibility_rounded,
            color: AppColors.primaryBlue,
            isSelected: true,
          ),
          const SizedBox(height: 10),
          _OutcomeCard(
            title: 'Referral Required',
            description: 'Pathology detected requiring specialist evaluation at referral center.',
            icon: Icons.local_hospital_rounded,
            color: AppColors.warning,
            isSelected: false,
          ),
          const SizedBox(height: 10),
          _OutcomeCard(
            title: 'Teleconsultation Required',
            description: 'Remote specialist review needed before final decision.',
            icon: Icons.video_call_rounded,
            color: AppColors.teleDocColor,
            isSelected: false,
          ),

          const SizedBox(height: 24),

          // Risk Scores
          Text('AI Risk Scores', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),

          _RiskScore('Cataract Risk', 0.34, AppColors.warning),
          const SizedBox(height: 10),
          _RiskScore('Glaucoma Risk', 0.08, AppColors.success),
          const SizedBox(height: 10),
          _RiskScore('Diabetic Retinopathy', 0.56, AppColors.error),
          const SizedBox(height: 10),
          _RiskScore('Blindness Risk', 0.12, AppColors.primaryBlue),

          const SizedBox(height: 20),

          // Doctor override
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Text('Doctor Override', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Override AI decision with clinical judgement if needed...',
                  ),
                ),
              ],
            ),
          ),
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

  const _OutcomeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
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
          if (isSelected)
            Icon(Icons.check_circle, color: color, size: 22),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
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
