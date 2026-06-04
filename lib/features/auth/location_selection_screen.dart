// lib/features/auth/location_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

const _districts = [
  'Krishna',
  'Guntur',
  'East Godavari',
  'West Godavari',
  'Visakhapatnam',
  'Kurnool',
  'Anantapur',
  'Chittoor',
  'Srikakulam',
  'Nellore',
];

const _mandalsByDistrict = {
  'Krishna': ['Vijayawada Urban', 'Machilipatnam', 'Nuzvid', 'Gudivada', 'Jaggaiahpet'],
  'Guntur': ['Guntur Urban', 'Tenali', 'Narasaraopet', 'Bapatla', 'Mangalagiri'],
  'East Godavari': ['Kakinada', 'Rajahmundry', 'Amalapuram', 'Peddapuram'],
  'West Godavari': ['Eluru', 'Bhimavaram', 'Tanuku', 'Nidadavole'],
  'Visakhapatnam': ['Visakhapatnam Urban', 'Anakapalle', 'Narsipatnam'],
  'Kurnool': ['Kurnool Urban', 'Nandyal', 'Adoni'],
  'Anantapur': ['Anantapur Urban', 'Hindupur', 'Dharmavaram'],
  'Chittoor': ['Tirupati', 'Chittoor', 'Madanapalle'],
  'Srikakulam': ['Palasa', 'Tekkali', 'Srikakulam Urban'],
  'Nellore': ['Nellore Urban', 'Kavali', 'Gudur'],
};

class LocationSelectionScreen extends ConsumerStatefulWidget {
  final String role;
  final String destinationRoute;

  const LocationSelectionScreen({
    super.key,
    required this.role,
    required this.destinationRoute,
  });

  @override
  ConsumerState<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends ConsumerState<LocationSelectionScreen> {
  String _district = 'Krishna';
  String _mandal = 'Vijayawada Urban';
  String _village = '';

  List<String> get _mandals => _mandalsByDistrict[_district] ?? ['Other'];

  @override
  void initState() {
    super.initState();
    _mandal = _mandals.first;
  }

  void _continue() {
    ref.read(sessionLocationProvider.notifier).state = (
      district: _district,
      mandal: _mandal,
      village: _village.isEmpty ? null : _village,
    );
    context.go(widget.destinationRoute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.role == 'nodal_officer'
        ? 'Select District Location'
        : 'Select Assigned Location';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your working location to continue',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _district,
              decoration: const InputDecoration(
                labelText: 'District',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              items: _districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _district = v;
                  _mandal = (_mandalsByDistrict[v] ?? ['Other']).first;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _mandal,
              decoration: const InputDecoration(
                labelText: 'Mandal',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: _mandals
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _mandal = v ?? _mandal),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Village / Camp Location (Optional)',
                prefixIcon: Icon(Icons.home_work_outlined),
                hintText: 'e.g. Krishnanagar',
              ),
              onChanged: (v) => _village = v,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
