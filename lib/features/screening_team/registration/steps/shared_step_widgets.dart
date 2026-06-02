// lib/features/screening_team/registration/steps/shared_step_widgets.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const StepTitle(this.title, this.subtitle, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.screeningTeamColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.screeningTeamColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}

class StepFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;

  const StepFormField(
    this.label, {
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class StepDropdownField extends StatelessWidget {
  final String label;
  final List<String> options;

  const StepDropdownField(this.label, this.options, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: Text('Select $label', overflow: TextOverflow.ellipsis),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}
