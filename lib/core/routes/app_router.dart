// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/role_selection_screen.dart';

import '../../features/patient/patient_shell.dart';
import '../../features/patient/patient_dashboard.dart';
import '../../features/patient/patient_profile.dart';
import '../../features/patient/prescription_list.dart';
import '../../features/patient/spectacle_tracking.dart';
import '../../features/patient/referral_screen.dart';
import '../../features/patient/teleconsultation_screen.dart';

import '../../features/screening_team/screening_shell.dart';
import '../../features/screening_team/screening_dashboard.dart';
import '../../features/screening_team/camp_management.dart';
import '../../features/screening_team/patient_search.dart';
import '../../features/screening_team/registration/registration_flow.dart';

import '../../features/nodal_officer/nodal_shell.dart';
import '../../features/nodal_officer/nodal_dashboard.dart';
import '../../features/nodal_officer/team_management.dart';
import '../../features/nodal_officer/approval_screen.dart';
import '../../features/nodal_officer/vendor_monitoring.dart';

import '../../features/tele_ophthalmologist/tele_shell.dart';
import '../../features/tele_ophthalmologist/tele_dashboard.dart';
import '../../features/tele_ophthalmologist/consultation_list.dart';
import '../../features/tele_ophthalmologist/video_consultation.dart';

import '../../features/vendor/vendor_shell.dart';
import '../../features/vendor/vendor_dashboard.dart';
import '../../features/vendor/order_details.dart';
import '../../features/vendor/delivery_verification.dart';

import '../../features/analytics/state_analytics.dart';
import '../../features/analytics/district_dashboard.dart';
import '../../features/analytics/ai_analytics.dart';
import '../../features/analytics/nutrition_analytics.dart';
import '../../features/analytics/school_vision_dashboard.dart';
import '../../features/analytics/elderly_care_dashboard.dart';
import '../../features/analytics/decision_support.dart';

import '../../features/emr/emr_timeline.dart';
import '../../features/emr/document_management.dart';
import '../../features/referral/referral_management.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/super_admin/super_admin_shell.dart';
import '../../features/super_admin/super_admin_dashboard.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/role-selection'),
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', redirect: (_, __) => '/role-selection'),
      GoRoute(path: '/otp', redirect: (_, __) => '/role-selection'),
      GoRoute(path: '/role-selection', builder: (_, __) => const RoleSelectionScreen()),

      // ── Patient ────────────────────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => PatientShell(child: child),
        routes: [
          GoRoute(path: '/patient/dashboard', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: '/patient/profile', builder: (_, __) => const PatientProfile()),
          GoRoute(path: '/patient/prescriptions', builder: (_, __) => const PrescriptionList()),
          GoRoute(path: '/patient/spectacles', builder: (_, __) => const SpectacleTracking()),
          GoRoute(path: '/patient/referrals', builder: (_, __) => const PatientReferralScreen()),
          GoRoute(path: '/patient/teleconsultation', builder: (_, __) => const TeleconsultationScreen()),
          GoRoute(path: '/patient/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Screening Team ─────────────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => ScreeningShell(child: child),
        routes: [
          GoRoute(path: '/screening/dashboard', builder: (_, __) => const ScreeningDashboard()),
          GoRoute(path: '/screening/camps', builder: (_, __) => const CampManagement()),
          GoRoute(
            path: '/screening/search',
            builder: (_, __) => const PatientSearchScreen(),
            routes: [
              GoRoute(path: 'emr', builder: (_, __) => const EmrTimeline()),
            ],
          ),
          GoRoute(path: '/screening/register', builder: (_, __) => const RegistrationFlow()),
          GoRoute(path: '/screening/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Nodal Officer ──────────────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => NodalShell(child: child),
        routes: [
          GoRoute(path: '/nodal/dashboard', builder: (_, __) => const NodalDashboard()),
          GoRoute(path: '/nodal/teams', builder: (_, __) => const TeamManagement()),
          GoRoute(path: '/nodal/approvals', builder: (_, __) => const ApprovalScreen()),
          GoRoute(path: '/nodal/vendors', builder: (_, __) => const VendorMonitoring()),
          GoRoute(path: '/nodal/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Tele-Ophthalmologist ───────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => TeleShell(child: child),
        routes: [
          GoRoute(path: '/tele/dashboard', builder: (_, __) => const TeleDashboard()),
          GoRoute(path: '/tele/consultations', builder: (_, __) => const ConsultationList()),
          GoRoute(path: '/tele/video', builder: (_, __) => const VideoConsultationScreen()),
          GoRoute(path: '/tele/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Vendor ────────────────────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => VendorShell(child: child),
        routes: [
          GoRoute(path: '/vendor/dashboard', builder: (_, __) => const VendorDashboard()),
          GoRoute(path: '/vendor/order/:id', builder: (_, s) => OrderDetailsScreen(orderId: s.pathParameters['id'] ?? '')),
          GoRoute(path: '/vendor/delivery', builder: (_, __) => const DeliveryVerification()),
          GoRoute(path: '/vendor/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Super Admin ────────────────────────────────────────────────
      ShellRoute(
        builder: (_, __, child) => SuperAdminShell(child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: (_, __) => const SuperAdminDashboard()),
          GoRoute(path: '/admin/analytics/state', builder: (_, __) => const StateAnalyticsDashboard()),
          GoRoute(path: '/admin/analytics/district', builder: (_, __) => const DistrictDashboard()),
          GoRoute(path: '/admin/analytics/ai', builder: (_, __) => const AiAnalyticsDashboard()),
          GoRoute(path: '/admin/analytics/nutrition', builder: (_, __) => const NutritionAnalytics()),
          GoRoute(path: '/admin/analytics/school', builder: (_, __) => const SchoolVisionDashboard()),
          GoRoute(path: '/admin/analytics/elderly', builder: (_, __) => const ElderlyCare()),
          GoRoute(path: '/admin/analytics/decision', builder: (_, __) => const DecisionSupportDashboard()),
          GoRoute(path: '/admin/emr', builder: (_, __) => const EmrTimeline()),
          GoRoute(path: '/admin/documents', builder: (_, __) => const DocumentManagementScreen()),
          GoRoute(path: '/admin/referrals', builder: (_, __) => const ReferralManagement()),
          GoRoute(path: '/admin/reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '/admin/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
