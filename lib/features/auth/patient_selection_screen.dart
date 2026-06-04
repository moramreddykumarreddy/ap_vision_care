// lib/features/auth/patient_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';
import '../../providers/app_providers.dart';

class PatientSelectionScreen extends ConsumerWidget {
  final String mobile;

  const PatientSelectionScreen({super.key, required this.mobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final patients = ref
        .watch(patientsProvider)
        .where((p) => p.mobile == mobile || mobile.isEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Patient'),
        backgroundColor: AppColors.patientColor,
      ),
      body: patients.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No patients registered with +91 $mobile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Patients registered with +91 $mobile',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select your profile to continue',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ...patients.map((p) => _PatientTile(
                      patient: p,
                      onTap: () {
                        ref.read(selectedPatientProvider.notifier).state = p;
                        context.go('/patient/dashboard');
                      },
                    )),
              ],
            ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;

  const _PatientTile({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.patientColor.withOpacity(0.12),
          child: Text(
            patient.name[0],
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.patientColor,
            ),
          ),
        ),
        title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${patient.age} yrs • ${patient.gender} • ${patient.village}, ${patient.district}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
