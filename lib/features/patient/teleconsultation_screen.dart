// lib/features/patient/teleconsultation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class TeleconsultationScreen extends StatefulWidget {
  const TeleconsultationScreen({super.key});

  @override
  State<TeleconsultationScreen> createState() => _TeleconsultationScreenState();
}

class _TeleconsultationScreenState extends State<TeleconsultationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teleconsultation'),
        leading: const AppBarBackButton(),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Video'),
            Tab(text: 'Chat'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _VideoConsultationTab(),
          _ChatTab(),
          _ReportsUploadTab(),
        ],
      ),
    );
  }
}

class _VideoConsultationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Scheduled consultation card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.heroGradient,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dr. Anita Rao',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Senior Ophthalmologist',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'SVIMS Hospital, Tirupati',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Scheduled',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoChip(Icons.calendar_today, '25 Mar 2024'),
                      _InfoChip(Icons.access_time, '10:30 AM'),
                      _InfoChip(Icons.timer, '30 min'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call, size: 20),
                  label: const Text('Join Consultation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.teleDocColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          // Past consultations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionHeader(title: 'Past Consultations'),
          ),
          const SizedBox(height: 8),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.teleDocColor.withOpacity(0.12),
                child: const Icon(Icons.video_call, color: AppColors.teleDocColor),
              ),
              title: const Text('Dr. Venkat Kumar', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('24 Mar 2024 • 18 min • Post-cataract consultation'),
              trailing: const StatusBadge(label: 'Completed'),
            ),
          ).animate(delay: 100.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
      ],
    );
  }
}

class _ChatTab extends StatefulWidget {
  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final _controller = TextEditingController();
  final List<_ChatMsg> _msgs = [
    _ChatMsg('Doctor', 'Hello, I have reviewed your latest eye test results. How are you feeling?', false),
    _ChatMsg('Me', 'I have been experiencing some blurred vision in the mornings, Doctor.', true),
    _ChatMsg('Doctor', 'That is common after the procedure. Please continue the prescribed eye drops twice daily.', false),
    _ChatMsg('Me', 'Should I avoid screens?', true),
    _ChatMsg('Doctor', 'Limit screen time to 2 hours per session. Take breaks every 20 minutes using the 20-20-20 rule.', false),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _msgs.length,
            itemBuilder: (context, i) {
              final msg = _msgs[i];
              return Align(
                alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                  decoration: BoxDecoration(
                    color: msg.isMe
                        ? AppColors.primaryBlue
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: msg.isMe ? const Radius.circular(4) : null,
                      bottomLeft: !msg.isMe ? const Radius.circular(4) : null,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isMe)
                        Text(
                          msg.sender,
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isMe ? Colors.white : theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 50).ms).fadeIn().slideY(begin: 0.2, end: 0);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMsg {
  final String sender;
  final String text;
  final bool isMe;
  const _ChatMsg(this.sender, this.text, this.isMe);
}

class _ReportsUploadTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Uploaded Reports', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          _ReportTile('Fundus Photo', 'image/jpeg', '2.3 MB', '20 Mar 2024'),
          _ReportTile('Blood Sugar Report', 'application/pdf', '1.1 MB', '18 Mar 2024'),
          _ReportTile('Field of Vision Test', 'image/png', '3.7 MB', '15 Mar 2024'),

          const SizedBox(height: 20),

          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryBlue.withOpacity(0.04),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primaryBlue, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload Report / Image',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG, PDF up to 10 MB',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final String name;
  final String type;
  final String size;
  final String date;

  const _ReportTile(this.name, this.type, this.size, this.date);

  @override
  Widget build(BuildContext context) {
    final isPdf = type.contains('pdf');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isPdf ? AppColors.error.withOpacity(0.1) : AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isPdf ? Icons.picture_as_pdf : Icons.image,
            color: isPdf ? AppColors.error : AppColors.info,
            size: 22,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('$size • $date'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.visibility, size: 20), onPressed: () {}),
            IconButton(icon: const Icon(Icons.download, size: 20), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
