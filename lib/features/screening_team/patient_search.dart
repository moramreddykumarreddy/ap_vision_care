// lib/features/screening_team/patient_search.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class PatientSearchScreen extends ConsumerStatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  ConsumerState<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends ConsumerState<PatientSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final patients = ref.watch(filteredPatientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Search'),
        backgroundColor: AppColors.screeningTeamColor,
        leading: const AppBarBackButton(),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Mobile / ABHA'),
            Tab(text: 'QR Scan'),
            Tab(text: 'Browse All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Search by mobile/ABHA
          _SearchTab(
            patients: patients,
            searchController: _searchController,
            onSearchChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          ),

          // Tab 2: QR Scan placeholder
          _QrScanTab(),

          // Tab 3: All patients
          _AllPatientsTab(patients: patients),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/screening/register'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('New Patient'),
        backgroundColor: AppColors.screeningTeamColor,
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  final List patients;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _SearchTab({
    required this.patients,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by mobile number or ABHA...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ),

        if (patients.isEmpty)
          const Expanded(
            child: EmptyState(
              icon: Icons.search_off,
              title: 'No patients found',
              message: 'Try searching with a different mobile number or ABHA',
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: patients.length,
              itemBuilder: (context, i) => _PatientTile(patient: patients[i]),
            ),
          ),
      ],
    );
  }
}

class _QrScanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.screeningTeamColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 80,
                  color: AppColors.screeningTeamColor,
                ),
                // Corner decorations
                Positioned(
                  top: 0, left: 0,
                  child: _Corner(Colors.white, true, true),
                ),
                Positioned(
                  top: 0, right: 0,
                  child: _Corner(Colors.white, true, false),
                ),
                Positioned(
                  bottom: 0, left: 0,
                  child: _Corner(Colors.white, false, true),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: _Corner(Colors.white, false, false),
                ),
              ],
            ),
          ).animate().scale(duration: 400.ms),

          const SizedBox(height: 24),
          Text(
            'Scan Patient QR Code',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Point camera at the patient\'s QR code\nto quickly look up their records',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_rounded, size: 18),
            label: const Text('Open Camera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.screeningTeamColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Color color;
  final bool isTop;
  final bool isLeft;
  const _Corner(this.color, this.isTop, this.isLeft);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: AppColors.screeningTeamColor, width: 4) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: AppColors.screeningTeamColor, width: 4) : BorderSide.none,
          left: isLeft ? BorderSide(color: AppColors.screeningTeamColor, width: 4) : BorderSide.none,
          right: !isLeft ? BorderSide(color: AppColors.screeningTeamColor, width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _AllPatientsTab extends StatelessWidget {
  final List patients;
  const _AllPatientsTab({required this.patients});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, i) => _PatientTile(patient: patients[i]),
    );
  }
}

class _PatientTile extends StatelessWidget {
  final dynamic patient;
  const _PatientTile({required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.screeningTeamColor.withOpacity(0.12),
          child: Text(
            patient.name[0],
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.screeningTeamColor,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${patient.age}y • ${patient.gender} • ${patient.mobile}'),
            Text(
              'ABHA: ${patient.abhaNumber}',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.go('/screening/search/emr');
        },
        isThreeLine: true,
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
