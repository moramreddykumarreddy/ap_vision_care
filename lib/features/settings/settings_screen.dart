// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            _SettingsSection(
              title: 'Profile',
              children: [
                _SettingsTile(Icons.person_outline_rounded, 'Edit Profile', onTap: () {}),
                _SettingsTile(Icons.lock_outline_rounded, 'Change PIN', onTap: () {}),
                _SettingsTile(Icons.fingerprint_rounded, 'Biometric Login', onTap: () {}),
              ],
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            _SettingsSection(
              title: 'Appearance',
              children: [
                ListTile(
                  leading: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.primaryBlue, size: 20),
                  ),
                  title: const Text('Dark Mode'),
                  trailing: Switch.adaptive(
                    value: isDark,
                    onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                    activeColor: AppColors.primaryBlue,
                  ),
                ),
                _SettingsTile(Icons.translate_rounded, 'Language', subtitle: 'English / Telugu', onTap: () {}),
                _SettingsTile(Icons.text_fields_rounded, 'Font Size', subtitle: 'Medium', onTap: () {}),
              ],
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 16),

            _SettingsSection(
              title: 'Notifications',
              children: [
                _SettingsToggle(Icons.notifications_active_rounded, 'Push Notifications', true),
                _SettingsToggle(Icons.sms_rounded, 'SMS Alerts', true),
                _SettingsToggle(Icons.email_rounded, 'Email Reports', false),
              ],
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 16),

            _SettingsSection(
              title: 'Security & Privacy',
              children: [
                _SettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', onTap: () {}),
                _SettingsTile(Icons.description_outlined, 'Terms of Service', onTap: () {}),
                _SettingsTile(Icons.security_rounded, 'Data Encryption', subtitle: 'AES-256 Enabled', onTap: () {}),
                _SettingsTile(Icons.verified_user_rounded, 'Audit Log', onTap: () {}),
              ],
            ).animate(delay: 300.ms).fadeIn(),

            const SizedBox(height: 16),

            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(Icons.info_outline_rounded, 'App Version', subtitle: 'v1.0.0 (Build 2024.03)', onTap: () {}),
                _SettingsTile(Icons.help_outline_rounded, 'Help & Support', onTap: () {}),
                _SettingsTile(Icons.feedback_outlined, 'Send Feedback', onTap: () {}),
              ],
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 20),

            // Logout
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogCtx);
                          context.go('/role-selection');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 52),
              ),
            ).animate(delay: 500.ms).fadeIn(),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'AP Vision Program • Government of Andhra Pradesh\nAll data is encrypted and protected.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey[500],
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile(this.icon, this.title, {this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 11)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _SettingsToggle extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool initialValue;

  const _SettingsToggle(this.icon, this.title, this.initialValue);

  @override
  State<_SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<_SettingsToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(widget.icon, color: AppColors.primaryBlue, size: 20),
      ),
      title: Text(widget.title, style: const TextStyle(fontSize: 14)),
      trailing: Switch.adaptive(
        value: _value,
        onChanged: (v) => setState(() => _value = v),
        activeColor: AppColors.primaryBlue,
      ),
    );
  }
}
