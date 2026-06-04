// lib/features/nodal_officer/approval_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models/models.dart';
import '../../providers/app_providers.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  const ApprovalScreen({super.key});

  @override
  ConsumerState<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _remarksControllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _remarksControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _remarksFor(String id) =>
      _remarksControllers.putIfAbsent(id, TextEditingController.new);

  void _updatePrescription(String id, String status, {String? remarks}) {
    final list = ref.read(prescriptionsProvider);
    ref.read(prescriptionsProvider.notifier).state = list.map((rx) {
      if (rx.id != id) return rx;
      return PrescriptionModel(
        id: rx.id,
        patientId: rx.patientId,
        patientName: rx.patientName,
        date: rx.date,
        doctorName: rx.doctorName,
        diagnosis: rx.diagnosis,
        rightEyeSph: rx.rightEyeSph,
        rightEyeCyl: rx.rightEyeCyl,
        rightEyeAxis: rx.rightEyeAxis,
        leftEyeSph: rx.leftEyeSph,
        leftEyeCyl: rx.leftEyeCyl,
        leftEyeAxis: rx.leftEyeAxis,
        status: remarks != null && status == 'Rejected' ? 'Rejected: $remarks' : status,
        spectacleStatus: status == 'Approved'
            ? SpectacleStatus.vendorAssigned
            : rx.spectacleStatus,
      );
    }).toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(status == 'Approved' ? 'Prescription approved' : 'Prescription rejected and returned to team'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateReferral(String id, String status) {
    final list = ref.read(referralsProvider);
    ref.read(referralsProvider.notifier).state = list.map((r) {
      if (r.id != id) return r;
      return ReferralModel(
        id: r.id,
        patientName: r.patientName,
        patientId: r.patientId,
        hospital: r.hospital,
        condition: r.condition,
        priority: r.priority,
        status: status,
        date: r.date,
        doctorName: r.doctorName,
      );
    }).toList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Referral $status'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prescriptions = ref.watch(prescriptionsProvider);
    final referrals = ref.watch(referralsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approvals'),
        backgroundColor: AppColors.nodalOfficerColor,
        leading: const AppBarBackButton(),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Prescriptions (${prescriptions.where((p) => p.status.contains('Pending')).length})'),
            Tab(text: 'Referrals (${referrals.where((r) => r.status == 'Pending').length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PrescriptionApprovalList(
            prescriptions: prescriptions,
            remarksFor: _remarksFor,
            onApprove: (id) => _updatePrescription(id, 'Approved'),
            onReject: (id, remarks) => _updatePrescription(id, 'Rejected', remarks: remarks),
          ),
          _ReferralApprovalList(
            referrals: referrals,
            onApprove: (id) => _updateReferral(id, 'Approved'),
            onReject: (id) => _updateReferral(id, 'Rejected'),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionApprovalList extends StatelessWidget {
  final List<PrescriptionModel> prescriptions;
  final TextEditingController Function(String id) remarksFor;
  final void Function(String id) onApprove;
  final void Function(String id, String remarks) onReject;

  const _PrescriptionApprovalList({
    required this.prescriptions,
    required this.remarksFor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = prescriptions.where((p) => p.status.contains('Pending')).toList();
    final others = prescriptions.where((p) => !p.status.contains('Pending')).toList();
    final items = [...pending, ...others];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final rx = items[i];
        final isPending = rx.status.contains('Pending');
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.nodalOfficerColor.withOpacity(0.1),
                      child: Text(rx.patientName[0], style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.nodalOfficerColor)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rx.patientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          Text('${rx.diagnosis} • ${rx.date}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    StatusBadge(label: rx.status.replaceAll('Pending Approval', 'Pending')),
                  ],
                ),
                const Divider(height: 16),
                if (isPending) ...[
                  TextField(
                    controller: remarksFor(rx.id),
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Add remarks (required for rejection)...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final remarks = remarksFor(rx.id).text.trim();
                            if (remarks.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter rejection remarks')),
                              );
                              return;
                            }
                            onReject(rx.id, remarks);
                          },
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Reject'),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onApprove(rx.id),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ] else
                  Text(rx.status, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
        ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
      },
    );
  }
}

class _ReferralApprovalList extends StatelessWidget {
  final List<ReferralModel> referrals;
  final void Function(String id) onApprove;
  final void Function(String id) onReject;

  const _ReferralApprovalList({
    required this.referrals,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: referrals.length,
      itemBuilder: (context, i) {
        final ref_ = referrals[i];
        final isPending = ref_.status == 'Pending';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_hospital, color: AppColors.error, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ref_.patientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          Text(ref_.hospital, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                          Text(ref_.condition, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue)),
                        ],
                      ),
                    ),
                    StatusBadge(label: ref_.priority),
                  ],
                ),
                if (isPending) ...[
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onApprove(ref_.id),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Approve Referral'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () => onReject(ref_.id),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ).animate(delay: (i * 80).ms).fadeIn();
      },
    );
  }
}
