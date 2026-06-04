// lib/features/analytics/demographic_analytics.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class DemographicAnalytics extends StatelessWidget {
  const DemographicAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demographic Analytics'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Gender Wise', theme: theme, items: [
            ('Male', '52%'), ('Female', '47%'), ('Others', '1%'),
          ]),
          _Section(title: 'Age Wise', theme: theme, items: [
            ('0-18', '28%'), ('19-40', '34%'), ('41-60', '24%'), ('Above 60', '14%'),
          ]),
          _Section(title: 'Occupation Wise', theme: theme, items: [
            ('Students', '22%'), ('Farmers', '18%'), ('Labourers', '24%'),
            ('Government Employees', '8%'), ('Others', '28%'),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final List<(String, String)> items;

  const _Section({required this.title, required this.theme, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 8),
        ...items.map((item) {
          final (label, value) = item;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(label),
              trailing: Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
