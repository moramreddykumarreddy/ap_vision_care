// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final fontFamily = ref.watch(fontFamilyProvider);
    final fontSize = ref.watch(fontSizeProvider);

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
                _SettingsTile(
                  Icons.translate_rounded,
                  'Language',
                  subtitle: 'English',
                  onTap: () => _showLanguageSelector(context, ref),
                ),
                _SettingsTile(
                  Icons.font_download_rounded,
                  'Font Style',
                  subtitle: fontFamily,
                  onTap: () => _showTypographySelector(context, ref),
                ),
                _SettingsTile(
                  Icons.text_fields_rounded,
                  'Font Size',
                  subtitle: fontSize,
                  onTap: () => _showTypographySelector(context, ref),
                ),
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

  void _showTypographySelector(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final activeFont = ref.watch(fontFamilyProvider);
            final activeSize = ref.watch(fontSizeProvider);

            final fontOptions = [
              {'name': 'Outfit', 'desc': 'Modern & Friendly'},
              {'name': 'Poppins', 'desc': 'Geometric & Bold'},
              {'name': 'Inter', 'desc': 'Clean & Neutral'},
              {'name': 'Lexend', 'desc': 'Highly Readable'},
              {'name': 'Roboto', 'desc': 'Standard Sans'},
            ];

            final sizeOptions = [
              {'name': 'Small', 'label': 'A', 'desc': '85%', 'iconSize': 14.0},
              {'name': 'Medium', 'label': 'A', 'desc': '100% (Default)', 'iconSize': 18.0},
              {'name': 'Large', 'label': 'A', 'desc': '115%', 'iconSize': 22.0},
              {'name': 'Extra Large', 'label': 'A', 'desc': '130%', 'iconSize': 26.0},
            ];

            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Typography & Font Settings',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Customize interface text display',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Live Preview Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [AppColors.darkCard, AppColors.darkCard.withOpacity(0.7)]
                            : [AppColors.primaryBlue.withOpacity(0.04), AppColors.primaryBlue.withOpacity(0.005)],
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.primaryBlue.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'LIVE PREVIEW',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.blue[300] : AppColors.primaryBlue,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$activeFont • $activeSize',
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'AP Digital Vision Care Platform',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'This preview text updates live as you select different font styles and text scaling sizes. The layout will adapt dynamically across the application.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 350.ms).slideY(begin: 0.1),

                  const SizedBox(height: 20),

                  // Font Family List
                  Text(
                    'FONT FAMILY',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 76,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fontOptions.length,
                      itemBuilder: (context, index) {
                        final option = fontOptions[index];
                        final name = option['name']!;
                        final desc = option['desc']!;
                        final isSelected = activeFont == name;

                        // Resolve font for rendering option names
                        TextStyle fontStyle;
                        switch (name) {
                          case 'Poppins':
                            fontStyle = GoogleFonts.poppins(fontWeight: FontWeight.w600);
                            break;
                          case 'Inter':
                            fontStyle = GoogleFonts.inter(fontWeight: FontWeight.w600);
                            break;
                          case 'Roboto':
                            fontStyle = GoogleFonts.roboto(fontWeight: FontWeight.w600);
                            break;
                          case 'Lexend':
                            fontStyle = GoogleFonts.lexend(fontWeight: FontWeight.w600);
                            break;
                          case 'Outfit':
                          default:
                            fontStyle = GoogleFonts.outfit(fontWeight: FontWeight.w600);
                            break;
                        }

                        return GestureDetector(
                          onTap: () {
                            ref.read(fontFamilyProvider.notifier).state = name;
                          },
                          child: AnimatedContainer(
                            duration: 200.ms,
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? AppColors.primaryBlue.withOpacity(0.2) : AppColors.primaryBlue.withOpacity(0.06))
                                  : (isDark ? AppColors.darkCard : AppColors.grey50),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : (isDark ? AppColors.darkBorder : AppColors.grey300),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: fontStyle.copyWith(
                                    fontSize: 15,
                                    color: isSelected
                                        ? (isDark ? Colors.blue[300] : AppColors.primaryBlue)
                                        : (isDark ? Colors.white : AppColors.grey900),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  desc,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate(delay: 100.ms).fade(duration: 350.ms).slideY(begin: 0.1),

                  const SizedBox(height: 20),

                  // Font Size Selector
                  Text(
                    'TEXT SCALE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: sizeOptions.map((opt) {
                      final name = opt['name'] as String;
                      final label = opt['label'] as String;
                      final desc = opt['desc'] as String;
                      final size = opt['iconSize'] as double;
                      final isSelected = activeSize == name;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(fontSizeProvider.notifier).state = name;
                          },
                          child: AnimatedContainer(
                            duration: 200.ms,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? AppColors.primaryBlue.withOpacity(0.2) : AppColors.primaryBlue.withOpacity(0.06))
                                  : (isDark ? AppColors.darkCard : AppColors.grey50),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : (isDark ? AppColors.darkBorder : AppColors.grey300),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: size,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? (isDark ? Colors.blue[300] : AppColors.primaryBlue)
                                        : (isDark ? Colors.white : AppColors.grey900),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected
                                        ? (isDark ? Colors.blue[300] : AppColors.primaryBlue)
                                        : (isDark ? Colors.white : AppColors.grey900),
                                  ),
                                ),
                                Text(
                                  desc,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate(delay: 200.ms).fade(duration: 350.ms).slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(fontFamilyProvider.notifier).state = 'Outfit';
                            ref.read(fontSizeProvider.notifier).state = 'Medium';
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Reset to Defaults'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Typography settings applied successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Apply Settings'),
                        ),
                      ),
                    ],
                  ).animate(delay: 300.ms).fade(duration: 350.ms).slideY(begin: 0.1),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Language / భాష ఎంచుకోండి',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                title: const Text('English (UK/US)', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue),
                onTap: () => Navigator.pop(context),
              ),
              Divider(color: isDark ? AppColors.darkBorder : AppColors.grey200),
              ListTile(
                leading: const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                title: const Text('తెలుగు (Telugu)', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Telugu language packs will download in background.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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
