// lib/features/super_admin/audit_logs_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  static const _logs = [
    ('2025-06-04 10:22', 'Nodal Officer', 'Approved prescription RX004'),
    ('2025-06-04 09:15', 'Screening Team', 'Registered patient P004'),
    ('2025-06-03 16:40', 'Super Admin', 'Updated vendor SLA configuration'),
    ('2025-06-03 14:02', 'Vendor', 'Marked order ORD-012 dispatched'),
    ('2025-06-03 11:30', 'Tele-Ophthalmologist', 'Completed teleconsult TC-089'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit & Compliance'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        itemBuilder: (context, i) {
          final (time, role, action) = _logs[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.history, color: AppColors.primaryBlue),
              title: Text(action, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text('$time • $role'),
            ),
          );
        },
      ),
    );
  }
}
