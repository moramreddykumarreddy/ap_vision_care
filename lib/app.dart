// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_providers.dart';

class ApVisionCareApp extends ConsumerWidget {
  const ApVisionCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);
    final fontFamily = ref.watch(fontFamilyProvider);
    final sizeScale = ref.watch(fontSizeScaleProvider);

    return MaterialApp.router(
      title: 'AP Vision Care',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme(fontFamily: fontFamily, sizeScale: sizeScale),
      darkTheme: AppTheme.darkTheme(fontFamily: fontFamily, sizeScale: sizeScale),
      routerConfig: router,
    );
  }
}
