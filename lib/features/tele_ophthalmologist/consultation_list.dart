// lib/features/tele_ophthalmologist/consultation_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class ConsultationList extends ConsumerWidget {
  const ConsultationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultations = ref.watch(teleconsultationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations'),
        backgroundColor: AppColors.teleDocColor,
        leading: const AppBarBackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: consultations.length,
        itemBuilder: (context, i) {
          final c = consultations[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.teleDocColor.withOpacity(0.1),
                        child: Text(c.patientName[0], style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.teleDocColor, fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.patientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text(c.condition, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      StatusBadge(label: c.status),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(child: InfoRow(label: 'Scheduled', value: c.scheduledTime)),
                      if (c.duration > 0) Expanded(child: InfoRow(label: 'Duration', value: '${c.duration} mins')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (c.status == 'Scheduled')
                    ElevatedButton.icon(
                      onPressed: () => context.go('/tele/video'),
                      icon: const Icon(Icons.video_call, size: 18),
                      label: const Text('Join Consultation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teleDocColor,
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View Summary'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                ],
              ),
            ),
          ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
        },
      ),
    );
  }
}
