// lib/features/reports/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _reports = [
    _Report('Monthly Screening Report - March 2024', 'PDF', '2.3 MB', 'Mar 31, 2024', AppColors.error, Icons.picture_as_pdf_rounded),
    _Report('Prescription Summary - March 2024', 'XLSX', '1.1 MB', 'Mar 31, 2024', AppColors.success, Icons.table_chart_rounded),
    _Report('Vendor SLA Report - Q4 2024', 'PDF', '3.7 MB', 'Mar 28, 2024', AppColors.error, Icons.picture_as_pdf_rounded),
    _Report('District Coverage Analysis - Feb 2024', 'PDF', '4.2 MB', 'Feb 29, 2024', AppColors.error, Icons.picture_as_pdf_rounded),
    _Report('AI Risk Analysis Report', 'PDF', '2.8 MB', 'Mar 25, 2024', AppColors.error, Icons.picture_as_pdf_rounded),
    _Report('School Vision Program - March 2024', 'XLSX', '1.5 MB', 'Mar 28, 2024', AppColors.success, Icons.table_chart_rounded),
    _Report('Teleconsultation Summary', 'PDF', '1.9 MB', 'Mar 22, 2024', AppColors.error, Icons.picture_as_pdf_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Generate custom report
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryBlue.withOpacity(0.06),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('Generate Custom Report'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.schedule, size: 18),
                    label: const Text('Schedule'),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reports.length,
              itemBuilder: (context, i) {
                final report = _reports[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: report.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(report.icon, color: report.color, size: 22),
                    ),
                    title: Text(report.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: Text('${report.type} • ${report.size} • ${report.date}', style: const TextStyle(fontSize: 11)),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility, size: 16), SizedBox(width: 8), Text('View')])),
                        const PopupMenuItem(value: 'download', child: Row(children: [Icon(Icons.download, size: 16), SizedBox(width: 8), Text('Download')])),
                        const PopupMenuItem(value: 'share', child: Row(children: [Icon(Icons.share, size: 16), SizedBox(width: 8), Text('Share')])),
                      ],
                      onSelected: (v) {},
                    ),
                    isThreeLine: false,
                  ),
                ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Report {
  final String name;
  final String type;
  final String size;
  final String date;
  final Color color;
  final IconData icon;

  const _Report(this.name, this.type, this.size, this.date, this.color, this.icon);
}
