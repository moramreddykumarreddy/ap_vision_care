// lib/features/patient/patient_profile.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/theme/app_colors.dart';

class PatientProfile extends ConsumerWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: const AppBarBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.go('/role-selection'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.12),
                          child: const Icon(
                            Icons.person,
                            size: 52,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ravi Kumar Reddy',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'రవి కుమార్ రెడ్డి',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ABHA badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.heroGradient,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.qr_code, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'ABHA: 14-3456-7890-1234',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Personal Information
            _InfoSection(
              title: 'Personal Information',
              icon: Icons.person_outline,
              children: const [
                InfoRow(label: 'Age', value: '45 years', icon: Icons.cake_rounded),
                InfoRow(label: 'Gender', value: 'Male', icon: Icons.wc_rounded),
                InfoRow(label: 'Mobile', value: '+91 9876543210', icon: Icons.phone_rounded),
              ],
            ),

            const SizedBox(height: 12),

            // Address
            _InfoSection(
              title: 'Address',
              icon: Icons.location_on_outlined,
              children: const [
                InfoRow(label: 'Address', value: 'H.No 12-34, Krishnanagar Colony', icon: Icons.home_rounded),
                InfoRow(label: 'District', value: 'Krishna', icon: Icons.map_rounded),
                InfoRow(label: 'Mandal', value: 'Vijayawada Urban'),
                InfoRow(label: 'Village', value: 'Krishnanagar'),
                InfoRow(label: 'State', value: 'Andhra Pradesh'),
              ],
            ),

            const SizedBox(height: 12),

            // Socio-Economic
            _InfoSection(
              title: 'Socio-Economic Details',
              icon: Icons.people_outline,
              children: const [
                InfoRow(label: 'Education', value: 'Secondary School'),
                InfoRow(label: 'Occupation', value: 'Farmer'),
                InfoRow(label: 'Income', value: 'BPL (Below Poverty Line)'),
                InfoRow(label: 'Category', value: 'BC-A'),
                InfoRow(label: 'Area Type', value: 'Urban'),
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download Health Card'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/role-selection'),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
