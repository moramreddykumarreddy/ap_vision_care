// lib/features/auth/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class RoleItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const RoleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

const _roles = [
  RoleItem(
    id: 'screening_team',
    title: 'Screening Team',
    subtitle: 'Camp management & patient screening',
    icon: Icons.medical_services,
    color: AppColors.primaryBlue,
    route: '/screening/dashboard',
  ),
  RoleItem(
    id: 'tele_oph',
    title: 'Tele-Ophthalmologist',
    subtitle: 'Remote consultations & diagnosis',
    icon: Icons.video_call,
    color: AppColors.primaryBlue,
    route: '/tele/dashboard',
  ),
  RoleItem(
    id: 'vendor',
    title: 'Vendor',
    subtitle: 'Order manufacturing & delivery',
    icon: Icons.storefront,
    color: AppColors.primaryBlue,
    route: '/vendor/dashboard',
  ),
  RoleItem(
    id: 'patient',
    title: 'Patient',
    subtitle: 'View prescriptions & track spectacles',
    icon: Icons.person,
    color: AppColors.primaryBlue,
    route: '/patient/dashboard',
  ),
];

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D2347), Color(0xFF1A3A6B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Text(
                      'Select Your Role',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 6),
                    Text(
                      'Choose your role to access the right features',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ).animate(delay: 100.ms).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Role Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? size.width * 0.1 : 16,
                    vertical: 8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isTablet ? 1.2 : 1.0,
                  ),
                  itemCount: _roles.length,
                  itemBuilder: (context, i) {
                    final role = _roles[i];
                    return _RoleCard(role: role)
                        .animate(delay: (i * 80).ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.3, end: 0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final RoleItem role;
  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          final encodedRoute = Uri.encodeComponent(role.route);
          context.go('/login?role=${role.id}&route=$encodedRoute');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: role.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(role.icon, color: role.color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                role.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: role.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                role.subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
