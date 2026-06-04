// lib/features/patient/patient_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

class PatientDashboard extends ConsumerWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final patient = ref.watch(selectedPatientProvider) ??
        ref.watch(patientsProvider).firstWhere(
              (p) => p.id == 'P001',
              orElse: () => ref.watch(patientsProvider).first,
            );
    final prescriptions = ref.watch(prescriptionsProvider).where((p) => p.patientId == patient.id).toList();
    final referrals = ref.watch(referralsProvider).where((r) => r.patientId == patient.id).toList();
    final teleconsultations = ref.watch(teleconsultationsProvider).where((t) => t.patientId == patient.id).toList();
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AP Vision Care', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(
              'Good morning, ${patient.name.split(' ').first}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.go('/patient/settings'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded),
                onPressed: () {},
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ABHA Card
              _AbhaCard().animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 20),

              // Stats Grid
              SectionHeader(title: 'My Health Summary'),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  StatCard(
                    title: 'Total Prescriptions',
                    value: '${prescriptions.length}',
                    icon: Icons.description_rounded,
                    color: AppColors.primaryBlue,
                    onTap: () => context.go('/patient/prescriptions'),
                  ),
                  StatCard(
                    title: 'Spectacle Status',
                    value: 'Delivered',
                    icon: Icons.visibility_rounded,
                    color: AppColors.success,
                    subtitle: '✓',
                    onTap: () => context.go('/patient/spectacles'),
                  ),
                  StatCard(
                    title: 'Referrals',
                    value: '${referrals.length}',
                    icon: Icons.local_hospital_rounded,
                    color: AppColors.warning,
                    onTap: () => context.go('/patient/referrals'),
                  ),
                  StatCard(
                    title: 'Teleconsultations',
                    value: '${teleconsultations.length}',
                    icon: Icons.video_call_rounded,
                    color: AppColors.teleDocColor,
                    onTap: () => context.go('/patient/teleconsultation'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions
              SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),

              Row(
                children: [
                  _QuickAction(
                    icon: Icons.qr_code_rounded,
                    label: 'My QR',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickAction(
                    icon: Icons.video_call_rounded,
                    label: 'Tele-consult',
                    color: AppColors.teleDocColor,
                    onTap: () => context.go('/patient/teleconsultation'),
                  ),
                  const SizedBox(width: 12),
                  _QuickAction(
                    icon: Icons.download_rounded,
                    label: 'Download',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickAction(
                    icon: Icons.help_rounded,
                    label: 'Help',
                    color: AppColors.gold,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Prescriptions
              SectionHeader(
                title: 'Recent Prescriptions',
                actionLabel: 'View All',
                onAction: () => context.go('/patient/prescriptions'),
              ),
              const SizedBox(height: 12),

              ...prescriptions.take(2).map((rx) => _PrescriptionCard(prescription: rx)),

              const SizedBox(height: 24),

              // Notifications
              SectionHeader(title: 'Notifications'),
              const SizedBox(height: 12),
              ...notifications.take(3).map((n) => _NotificationTile(notification: n)),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AbhaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ravi Kumar Reddy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ABHA: 14-3456-7890-1234',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text(
                      'Krishna District, AP',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.qr_code, color: Colors.white, size: 36),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final dynamic prescription;
  const _PrescriptionCard({required this.prescription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description, color: AppColors.primaryBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription.diagnosis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Dr. ${prescription.doctorName} • ${prescription.date}',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                StatusBadge(label: prescription.status),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rx ID: ${prescription.id}',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download PDF'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _NotificationTile extends StatelessWidget {
  final dynamic notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? theme.colorScheme.surfaceContainerHighest
            : AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? theme.colorScheme.outline.withOpacity(0.3)
              : AppColors.primaryBlue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications, color: AppColors.primaryBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
