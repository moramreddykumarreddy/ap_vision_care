// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/role-selection');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D2347),
              Color(0xFF1A3A6B),
              Color(0xFF0D2347),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -60,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00897B).withOpacity(0.06),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Center(
                    child: Column(
                      children: [
                        // Animated logo container
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.04),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4D8AFF).withOpacity(0.3),
                                  blurRadius: 35,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/apvision.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),

                        const SizedBox(height: 28),

                        // App Title
                        const Text(
                          'AP Vision Program',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        )
                            .animate(delay: 300.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          'Government of Andhra Pradesh',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            .animate(delay: 400.ms)
                            .fadeIn(duration: 500.ms),

                        const SizedBox(height: 6),

                        Text(
                          'దృష్టి సేవ | Vision Service',
                          style: TextStyle(
                            color: const Color(0xFFD4A017).withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            .animate(delay: 500.ms)
                            .fadeIn(duration: 500.ms),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Loading indicator
                  Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF00897B),
                            ),
                            minHeight: 3,
                          ),
                        ),
                      )
                          .animate(delay: 600.ms)
                          .fadeIn(duration: 400.ms),

                      const SizedBox(height: 16),

                      Text(
                        'Department of Health, Medical & Family Welfare',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate(delay: 700.ms)
                          .fadeIn(duration: 400.ms),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
