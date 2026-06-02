// lib/providers/app_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/models.dart';
import '../data/dummy/dummy_data.dart';

// ─── Theme Provider ────────────────────────────────────────────────────────
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

// ─── Auth Provider ─────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoggedIn;
  final String? userRole;
  final String? userName;
  final String? userId;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isLoggedIn = false,
    this.userRole,
    this.userName,
    this.userId,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? userRole,
    String? userName,
    String? userId,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userRole: userRole ?? this.userRole,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String mobile, String otp, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    state = AuthState(
      isLoggedIn: true,
      userRole: role,
      userName: 'Ravi Kumar Reddy',
      userId: 'U001',
      isLoading: false,
    );
  }

  void logout() {
    state = AuthState();
  }
}

// ─── Patient Provider ──────────────────────────────────────────────────────
final patientsProvider = StateProvider<List<PatientModel>>((ref) {
  return DummyData.patients;
});

final prescriptionsProvider = StateProvider<List<PrescriptionModel>>((ref) {
  return DummyData.prescriptions;
});

final referralsProvider = StateProvider<List<ReferralModel>>((ref) {
  return DummyData.referrals;
});

final campsProvider = StateProvider<List<CampModel>>((ref) {
  return DummyData.camps;
});

final teleconsultationsProvider = StateProvider<List<TeleconsultationModel>>((ref) {
  return DummyData.teleconsultations;
});

final vendorOrdersProvider = StateProvider<List<VendorOrderModel>>((ref) {
  return DummyData.vendorOrders;
});

final notificationsProvider = StateProvider<List<NotificationModel>>((ref) {
  return DummyData.notifications;
});

// ─── Screening Registration Provider ──────────────────────────────────────
final registrationStepProvider = StateProvider<int>((ref) => 0);

final selectedSymptomsProvider = StateProvider<Set<String>>((ref) => {});
final selectedMedicalHistoryProvider = StateProvider<Set<String>>((ref) => {});
final selectedFamilyHistoryProvider = StateProvider<Set<String>>((ref) => {});

// ─── Camp Provider ─────────────────────────────────────────────────────────
final activeCampProvider = StateProvider<CampModel?>((ref) {
  return DummyData.camps.first;
});

// ─── Search Provider ───────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredPatientsProvider = Provider<List<PatientModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final patients = ref.watch(patientsProvider);
  if (query.isEmpty) return patients;
  return patients.where((p) =>
    p.name.toLowerCase().contains(query) ||
    p.mobile.contains(query) ||
    p.abhaNumber.contains(query)
  ).toList();
});

// ─── Analytics Provider ────────────────────────────────────────────────────
final analyticsProvider = Provider((ref) => DummyData.stateAnalytics);
final districtsProvider = Provider((ref) => DummyData.districts);
final aiRiskProvider = Provider((ref) => DummyData.aiRiskData);
final schoolVisionProvider = Provider((ref) => DummyData.schoolVisionData);
