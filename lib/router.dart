import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/role_select_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/loading_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/detail/detection_detail_screen.dart';
import 'features/pairing/add_child_screen.dart';
import 'features/pairing/scan_qr_screen.dart';
import 'features/pairing/active_screen.dart';
import 'features/education/education_screen.dart';
import 'features/settings/settings_screen.dart';
import 'services/channel_service.dart';
import 'features/pairing/onboarding_screen.dart';
import 'features/settings/edit_profile_screen.dart';
import 'features/dashboard/main_screen.dart';
import 'features/dashboard/child_detail_screen.dart';
import 'models/child.dart';

/// Editorial fade + slight upward slide used across the auth flow,
/// so role-select → login → main feel like one continuous journey.
Page<void> _fadeSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  navigatorKey: ChannelService.navigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/role-select',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const RoleSelectScreen()),
    ),
    GoRoute(
      path: '/main',
      pageBuilder: (context, state) => _fadeSlidePage(state, const MainScreen()),
    ),
    GoRoute(
      path: '/loading',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const LoadingScreen()),
    ),

    // Parent
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _fadeSlidePage(state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const RegisterScreen()),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/add-child',
      builder: (context, state) => const AddChildScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => DetectionDetailScreen(
        detectionId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/child/:id',
      builder: (context, state) => ChildDetailScreen(
        child: state.extra as Child,
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Child
    GoRoute(
      path: '/scan-qr',
      builder: (context, state) => const ScanQrScreen(),
    ),
    GoRoute(
      path: '/education',
      builder: (context, state) {
        // Receive extra from the Event Channel
        final extra = state.extra as Map<String, dynamic>?;
        return EducationScreen(
          keywords: List<String>.from(extra?['keywords'] ?? []),
          triggeredBy: extra?['triggeredBy']?.toString() ?? '',
          confidence: (extra?['confidence'] as num?)?.toDouble() ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/active',
      builder: (context, state) => const ActiveScreen(),
    ),
  ],
);
