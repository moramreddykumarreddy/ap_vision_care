// lib/features/auth/otp_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 30;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _verify() async {
    if (_otp.length == 6) {
      setState(() => _isVerifying = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isVerifying = false);
      if (mounted) {
        final state = GoRouterState.of(context);
        final route = state.uri.queryParameters['route'] ?? '';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified successfully! Logging in...'),
            backgroundColor: AppColors.brandBlue,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );

        final role = state.uri.queryParameters['role'] ?? '';
        final mobile = state.uri.queryParameters['mobile'] ?? widget.mobile;
        final encodedRoute = Uri.encodeComponent(route.isNotEmpty ? route : '/role-selection');

        if (role == 'patient') {
          context.go('/select-patient?mobile=$mobile');
        } else if (role == 'screening_team') {
          context.go('/select-location?role=$role&route=$encodedRoute');
        } else {
          context.go(route.isNotEmpty ? route : '/role-selection');
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.heroGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 24,
                vertical: 24,
              ),
              child: Column(
                children: [
                  // Back + Logo
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF81D4FA), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/apvision.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ).animate().scale(begin: const Offset(0.5, 0.5)),

                  const SizedBox(height: 20),

                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to +91 ${widget.mobile}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          // OTP boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (i) {
                              return SizedBox(
                                width: 44,
                                height: 52,
                                child: TextFormField(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onChanged: (v) {
                                    if (v.isNotEmpty && i < 5) {
                                      _focusNodes[i + 1].requestFocus();
                                    }
                                    if (v.isEmpty && i > 0) {
                                      _focusNodes[i - 1].requestFocus();
                                    }
                                    if (_otp.length == 6) _verify();
                                  },
                                ),
                              ).animate(delay: (i * 80).ms).fadeIn().slideX(begin: 0.3, end: 0);
                            }),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: _isVerifying ? null : _verify,
                            child: _isVerifying
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Verify & Continue'),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive OTP? ",
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                              if (_resendSeconds > 0)
                                Text(
                                  'Resend in ${_resendSeconds}s',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                )
                              else
                                TextButton(
                                  onPressed: () {
                                    setState(() => _resendSeconds = 30);
                                    _startTimer();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('New OTP sent successfully.'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                  ),
                                  child: const Text('Resend OTP'),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Demo: Enter any 6-digit OTP',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
