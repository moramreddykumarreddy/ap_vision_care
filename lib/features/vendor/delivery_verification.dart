// lib/features/vendor/delivery_verification.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class DeliveryVerification extends StatefulWidget {
  const DeliveryVerification({super.key});

  @override
  State<DeliveryVerification> createState() => _DeliveryVerificationState();
}

class _DeliveryVerificationState extends State<DeliveryVerification> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _photoTaken = false;
  bool _gpsConfirmed = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Verification'),
        backgroundColor: AppColors.vendorColor,
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.vendorColor, Color(0xFFFF8C00)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ravi Kumar Reddy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        const Text('+91 9876543210', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const Text('Krishnanagar, Vijayawada', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // OTP Verification
            Text('Patient OTP Verification', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              'Enter the 6-digit OTP sent to patient\'s mobile number',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => SizedBox(
                width: 46,
                height: 54,
                child: TextFormField(
                  controller: _otpControllers[i],
                  focusNode: _focusNodes[i],
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.vendorColor),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) _focusNodes[i + 1].requestFocus();
                    if (v.isEmpty && i > 0) _focusNodes[i - 1].requestFocus();
                  },
                ),
              ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.3, end: 0)),
            ),

            const SizedBox(height: 24),

            // Photo Capture
            Text('Delivery Photo', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _photoTaken = true),
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: _photoTaken ? AppColors.success.withOpacity(0.08) : theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: _photoTaken ? AppColors.success : theme.colorScheme.outline.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _photoTaken
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
                          const SizedBox(height: 8),
                          const Text('Photo Captured', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 36, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text('Tap to capture delivery photo', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // GPS Confirmation
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _gpsConfirmed ? AppColors.success.withOpacity(0.08) : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _gpsConfirmed ? AppColors.success : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: _gpsConfirmed ? AppColors.success : Colors.grey,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _gpsConfirmed ? 'GPS Location Confirmed' : 'Confirm GPS Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _gpsConfirmed ? AppColors.success : null,
                          ),
                        ),
                        Text(
                          _gpsConfirmed
                              ? '17.3850° N, 78.4867° E • Vijayawada'
                              : 'Tap to capture delivery GPS coordinates',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _gpsConfirmed,
                    onChanged: (v) => setState(() => _gpsConfirmed = v),
                    activeColor: AppColors.success,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: (_photoTaken && _gpsConfirmed && !_isSubmitting)
                  ? () async {
                      setState(() => _isSubmitting = true);
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() => _isSubmitting = false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delivery verified successfully!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  : null,
              icon: _isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.verified_rounded, size: 18),
              label: Text(_isSubmitting ? 'Verifying...' : 'Confirm Delivery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
