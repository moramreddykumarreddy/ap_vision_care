// lib/features/tele_ophthalmologist/tele_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class TeleDashboard extends ConsumerWidget {
  const TeleDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultations = ref.watch(teleconsultationsProvider);
    final theme = Theme.of(context);

    final pending = consultations.where((c) => c.status == 'Scheduled').length;
    final completed = consultations.where((c) => c.status == 'Completed').length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tele-Ophthalmologist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('Dr. Anita Rao • SVIMS, Tirupati', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.teleDocColor,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () => context.go('/tele/settings')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Next consultation card
            if (pending > 0)
              _NextConsultationCard(consultation: consultations.first)
                  .animate()
                  .fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            SectionHeader(title: "Today's Summary"),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              children: [
                StatCard(
                  title: 'Pending',
                  value: '$pending',
                  icon: Icons.pending_rounded,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'Completed',
                  value: '$completed',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Referrals',
                  value: '2',
                  icon: Icons.local_hospital_rounded,
                  color: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 20),

            SectionHeader(
              title: 'Consultation Queue',
              actionLabel: 'View All',
              onAction: () => context.go('/tele/consultations'),
            ),
            const SizedBox(height: 12),

            ...consultations.map((c) => _ConsultationCard(consultation: c)),
          ],
        ),
      ),
    );
  }
}

class _NextConsultationCard extends StatelessWidget {
  final dynamic consultation;
  const _NextConsultationCard({required this.consultation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teleDocColor, Color(0xFF01579B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('NEXT UP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(consultation.patientName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    Text(consultation.condition, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    Text(consultation.scheduledTime, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.video_call, size: 18),
            label: const Text('Join Consultation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.teleDocColor,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  final dynamic consultation;
  const _ConsultationCard({required this.consultation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.teleDocColor.withOpacity(0.1),
              child: Text(consultation.patientName[0], style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.teleDocColor)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consultation.patientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text(consultation.condition, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  Text(consultation.scheduledTime, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.teleDocColor)),
                ],
              ),
            ),
            StatusBadge(label: consultation.status),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
