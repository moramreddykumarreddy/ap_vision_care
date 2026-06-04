// lib/core/widgets/section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_providers.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? leading;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 8)],
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

// ─── Gov Header Banner ─────────────────────────────────────────────────────
class GovHeaderBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? backgroundColor;

  const GovHeaderBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? theme.colorScheme.primary,
            (backgroundColor ?? theme.colorScheme.primary).withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.visibility, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status Badge ──────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusBadge({super.key, required this.label, this.color});

  static Color _colorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF2E7D32);
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'dispatched':
        return const Color(0xFF0277BD);
      case 'manufacturing':
        return const Color(0xFFE65100);
      case 'pending':
        return const Color(0xFF757575);
      case 'rejected':
        return const Color(0xFFC62828);
      case 'active':
        return const Color(0xFF2E7D32);
      case 'scheduled':
        return const Color(0xFF6A1B9A);
      case 'completed':
        return const Color(0xFF00695C);
      case 'emergency':
        return const Color(0xFFC62828);
      case 'high':
        return const Color(0xFFE65100);
      case 'moderate':
        return const Color(0xFFD4A017);
      case 'routine':
        return const Color(0xFF0277BD);
      default:
        return const Color(0xFF757575);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = color ?? _colorForLabel(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─── Info Row ──────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const InfoRow({super.key, required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Loading Overlay ───────────────────────────────────────────────────────
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

// ─── AP Logo Widget ────────────────────────────────────────────────────────
class ApLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;

  const ApLogoWidget({super.key, this.size = 80, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A3A6B), Color(0xFF2952A3)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A3A6B).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.visibility, color: Colors.white, size: size * 0.4),
              Positioned(
                bottom: size * 0.15,
                child: Icon(
                  Icons.medical_services,
                  color: const Color(0xFFD4A017),
                  size: size * 0.18,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'AP Vision Program',
            style: TextStyle(
              fontSize: size * 0.18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'Government of Andhra Pradesh',
            style: TextStyle(
              fontSize: size * 0.13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }
}

class AppBarBackButton extends ConsumerWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const AppBarBackButton({super.key, this.color, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final isMobile = MediaQuery.of(context).size.width <= 768;
    final isAdmin = path.startsWith('/admin/');

    // Only show menu on screening path (previously admin)
    if (isMobile && path == '/screening/dashboard') {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(Icons.arrow_back, color: color ?? Colors.white),
      onPressed: onPressed ?? () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          try {
            if (path.startsWith('/tele/')) {
              context.go('/tele/dashboard');
            } else if (path.startsWith('/vendor/')) {
              context.go('/vendor/dashboard');
            } else if (path.startsWith('/screening/')) {
              context.go('/screening/dashboard');
            } else if (path.startsWith('/patient/')) {
              context.go('/patient/dashboard');
            } else {
              context.go('/role-selection');
            }
          } catch (e) {
            Navigator.of(context).maybePop();
          }
        }
      },
    );
  }
}
