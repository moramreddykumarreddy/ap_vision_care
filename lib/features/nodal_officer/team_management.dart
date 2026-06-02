// lib/features/nodal_officer/team_management.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class TeamManagement extends StatelessWidget {
  const TeamManagement({super.key});

  static final _teams = [
    _Team('Team Alpha', 'Dr. Venkata Rao', ['Dr. Priya', 'Nurse Lakshmi', 'Optometrist Suresh'], 'Nuzvid', 'Active'),
    _Team('Team Beta', 'Dr. Radha Krishna', ['Dr. Anand', 'Nurse Devi', 'Optometrist Ramu'], 'Chirala', 'Active'),
    _Team('Team Gamma', 'Dr. Nagendra Babu', ['Dr. Sunitha', 'Nurse Kavitha'], 'Rajahmundry', 'Scheduled'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
        backgroundColor: AppColors.nodalOfficerColor,
        leading: const AppBarBackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _teams.length,
        itemBuilder: (context, i) {
          final team = _teams[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.nodalOfficerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.group_rounded, color: AppColors.nodalOfficerColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(team.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Lead: ${team.lead}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      StatusBadge(label: team.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Assigned to: ${team.mandal}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Team Members:', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: team.members.map((m) => Chip(
                      label: Text(m, style: const TextStyle(fontSize: 11)),
                      avatar: CircleAvatar(
                        backgroundColor: AppColors.nodalOfficerColor.withOpacity(0.2),
                        child: Text(m[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit, size: 15),
                          label: const Text('Edit Team'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.my_location, size: 15),
                          label: const Text('Reassign'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.nodalOfficerColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTeamDialog(context),
        icon: const Icon(Icons.group_add),
        label: const Text('Create Team'),
        backgroundColor: AppColors.nodalOfficerColor,
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Team'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Team Name', prefixIcon: Icon(Icons.group))),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Team Lead Doctor', prefixIcon: Icon(Icons.person))),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Assigned Mandal', prefixIcon: Icon(Icons.location_on))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New team created successfully!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _Team {
  final String name;
  final String lead;
  final List<String> members;
  final String mandal;
  final String status;

  const _Team(this.name, this.lead, this.members, this.mandal, this.status);
}
