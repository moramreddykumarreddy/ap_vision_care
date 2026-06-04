// lib/features/tele_ophthalmologist/video_consultation.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class VideoConsultationScreen extends StatefulWidget {
  const VideoConsultationScreen({super.key});

  @override
  State<VideoConsultationScreen> createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isSpeakerOn = true;

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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/tele/consultations');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.circle, color: AppColors.brandRed, size: 10),
                  const SizedBox(width: 6),
                  const Text('LIVE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const Spacer(),
                  const Text('00:18:42', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main video area
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Remote video (patient)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                          child: const Text('RK', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 12),
                        const Text('Ravi Kumar Reddy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text('Patient • Krishna District', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),

                  // Local video (doctor) PiP
                  Positioned(
                    bottom: 12,
                    right: 24,
                    child: Container(
                      width: 90,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.brandBlue,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white30, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Text('AR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(height: 6),
                          const Text('You', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                  ),
                ],
              ),
            ),

            // Tab bar for notes/chat/prescription
            Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: AppColors.teleDocColor,
                tabs: const [
                  Tab(text: 'Notes'),
                  Tab(text: 'Chat'),
                  Tab(text: 'Actions'),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _NotesPanel(),
                  _ChatPanel(),
                  _ActionsPanel(),
                ],
              ),
            ),

            // Controls bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: AppColors.darkBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ControlButton(
                    icon: _isMicOn ? Icons.mic : Icons.mic_off,
                    label: _isMicOn ? 'Mute' : 'Unmute',
                    color: _isMicOn ? Colors.white : AppColors.error,
                    onTap: () => setState(() => _isMicOn = !_isMicOn),
                  ),
                  _ControlButton(
                    icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                    label: _isCameraOn ? 'Stop' : 'Start',
                    color: _isCameraOn ? Colors.white : AppColors.error,
                    onTap: () => setState(() => _isCameraOn = !_isCameraOn),
                  ),
                  _ControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    color: AppColors.error,
                    background: AppColors.error.withOpacity(0.2),
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go('/tele/consultations');
                      }
                    },
                    large: true,
                  ),
                  _ControlButton(
                    icon: Icons.screen_share,
                    label: 'Share',
                    color: Colors.white,
                    onTap: () {},
                  ),
                  _ControlButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    label: 'Speaker',
                    color: _isSpeakerOn ? Colors.white : AppColors.error,
                    onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? background;
  final VoidCallback onTap;
  final bool large;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.background,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: large ? 52 : 44,
            height: large ? 52 : 44,
            decoration: BoxDecoration(
              color: background ?? Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: large ? 26 : 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white60, fontSize: 9)),
        ],
      ),
    );
  }
}

class _NotesPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        maxLines: null,
        expands: true,
        style: TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Type consultation notes here...',
          hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _ChatPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _ChatBubble('Doctor', 'Please show me how you are holding the phone', false),
                _ChatBubble('Patient', 'Is this position okay?', true),
                _ChatBubble('Doctor', 'Yes, perfect. I can see your eyes clearly now.', false),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type message...',
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.teleDocColor,
                child: const Icon(Icons.send, color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isPatient;
  const _ChatBubble(this.sender, this.text, this.isPatient);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isPatient ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isPatient ? AppColors.primaryBlue.withOpacity(0.3) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w700)),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ActionsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          _ActionItem(Icons.description_rounded, 'Generate Prescription', AppColors.primaryBlue),
          const SizedBox(height: 8),
          _ActionItem(Icons.local_hospital_rounded, 'Refer to Hospital', AppColors.error),
          const SizedBox(height: 8),
          _ActionItem(Icons.camera_alt_rounded, 'Capture Fundus Photo', AppColors.accent),
          const SizedBox(height: 8),
          _ActionItem(Icons.share_rounded, 'Share Screen', AppColors.gold),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionItem(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.6), size: 14),
          ],
        ),
      ),
    );
  }
}
