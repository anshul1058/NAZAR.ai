import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Login → dashboard bridge. A "Guardian Scan": a gold radar sweep
/// pings the family, blips lock on, then shards fly in and assemble
/// the shield, which breathes before the dashboard fades in.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Timeline phases
  late final Animation<double> _sweep; // radar rotation 0→1
  late final Animation<double> _radarFade; // radar visibility
  late final Animation<double> _blips; // detection dots
  late final Animation<double> _shieldIn; // shards → shield
  late final Animation<double> _breathe; // post-assembly pulse
  late final Animation<double> _overlineIn;
  late final Animation<double> _headlineIn;
  late final Animation<double> _subtitleIn;
  late final Animation<double> _footerIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // 1. Radar sweep rotates a full turn, fades out near the end
    _sweep = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.42, curve: Curves.easeInOut),
    );
    _radarFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.55, curve: Curves.easeIn),
    );
    _blips = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.12, 0.4, curve: Curves.easeOut),
    );

    // 2. Shards fly in, shield assembles
    _shieldIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.72, curve: Curves.easeOutCubic),
    );

    // 3. Slow breathing after assembly
    _breathe = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1.0, curve: Curves.easeInOut),
    );

    // 4. Staggered copy
    _overlineIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 0.82, curve: Curves.easeOut),
    );
    _headlineIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 0.86, curve: Curves.easeOutCubic),
    );
    _subtitleIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 0.9, curve: Curves.easeOut),
    );
    _footerIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.88, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go('/main');
      }
    });

    // Fallback in case the animation never completes.
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) context.go('/main');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ─── Scan stage ───────────────────────────
              SizedBox(
                height: 240,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => SizedBox(
                      width: 240,
                      height: 240,
                      child: CustomPaint(
                        painter: _GuardianScanPainter(
                          sweep: _sweep.value,
                          radarFade: _radarFade.value,
                          blips: _blips.value,
                          shieldIn: _shieldIn.value,
                          breathe: 1.0 + 0.035 * math.sin(_breathe.value * math.pi),
                          gold: AppColors.primary,
                          espresso: AppColors.espresso,
                          cream: AppColors.buttonPrimaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Overline ─────────────────────────────
              FadeTransition(
                opacity: _overlineIn,
                child: Text(
                  'SECURITY SCAN COMPLETE',
                  style: AppTheme.overline(11, letterSpacing: 3.5),
                ),
              ),
              const SizedBox(height: 14),

              // ─── Headline ─────────────────────────────
              FadeTransition(
                opacity: _headlineIn,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_headlineIn),
                  child: const Text(
                    'All clear',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ─── Subtitle ─────────────────────────────
              FadeTransition(
                opacity: _subtitleIn,
                child: const Text(
                  'Your family is protected',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // ─── Brand ────────────────────────────────
              FadeTransition(
                opacity: _footerIn,
                child: Text(
                  'NAZAR.AI',
                  style: AppTheme.overline(11, letterSpacing: 3.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Guardian Scan painter ────────────────────────────
class _GuardianScanPainter extends CustomPainter {
  final double sweep; // 0 → 1 full rotation
  final double radarFade; // 1 = radar visible
  final double blips; // 0 → 1 blip lock-in
  final double shieldIn; // 0 → 1 shield assembly
  final double breathe; // gentle post-assembly pulse
  final Color gold;
  final Color espresso;
  final Color cream;

  _GuardianScanPainter({
    required this.sweep,
    required this.radarFade,
    required this.blips,
    required this.shieldIn,
    required this.breathe,
    required this.gold,
    required this.espresso,
    required this.cream,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final base = size.shortestSide;
    final radarR = base * 0.42;
    final radarVis = radarFade * (1 - shieldIn.clamp(0.0, 1.0) * 0.6);

    // ─── Radar ring + crosshair ───────────────────────
    if (radarVis > 0.02) {
      canvas.drawCircle(
        c,
        radarR * breathe,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = gold.withValues(alpha: 0.4 * radarVis),
      );
      canvas.drawCircle(
        c,
        radarR * 0.55 * breathe,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = gold.withValues(alpha: 0.18 * radarVis),
      );

      // crosshair
      final cross = Paint()
        ..strokeWidth = 1
        ..color = gold.withValues(alpha: 0.15 * radarVis);
      canvas.drawLine(c - Offset(radarR, 0), c + Offset(radarR, 0), cross);
      canvas.drawLine(c - Offset(0, radarR), c + Offset(0, radarR), cross);

      // rotating sweep line + arc trail
      final angle = sweep * 2 * math.pi;
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        c,
        c + dir * radarR,
        Paint()
          ..strokeWidth = 2
          ..color = gold.withValues(alpha: 0.8 * radarVis),
      );

      final arcRect = Rect.fromCircle(center: c, radius: radarR * 0.98);
      canvas.drawArc(
        arcRect,
        -math.pi / 2 + angle - 0.7,
        0.7,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..color = gold.withValues(alpha: 0.10 * radarVis),
      );
    }

    // ─── Detection blips (ping, then lock into ring) ──
    if (blips > 0.02) {
      const spots = [
        Offset(0.62, 0.20),
        Offset(-0.55, 0.38),
        Offset(0.30, -0.62),
        Offset(-0.72, -0.18),
        Offset(0.10, 0.66),
      ];
      for (var i = 0; i < spots.length; i++) {
        final local = blips.clamp(0.0, 1.0) - i * 0.16;
        if (local <= 0) continue;
        final fade = (local * 2.2).clamp(0.0, 1.0);
        final spot = spots[i];
        final pos = c + Offset(spot.dx, spot.dy) * radarR * breathe;

        // ping ring
        final ping = 1 + (1 - local.clamp(0.0, 1.0)) * 2.2;
        canvas.drawCircle(
          pos,
          8 * ping,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = gold.withValues(alpha: 0.4 * fade),
        );
        canvas.drawCircle(
          pos,
          3.4,
          Paint()..color = gold.withValues(alpha: fade),
        );
      }
    }

    // ─── Shield assembly from flying shards ───────────
    if (shieldIn > 0.02) {
      final t = shieldIn.clamp(0.0, 1.0);

      // shards converge from the rim
      final shardPaint = Paint()..color = gold.withValues(alpha: 0.5 * (1 - t));
      for (var i = 0; i < 14; i++) {
        final a = (i / 14) * 2 * math.pi;
        final from = radarR * 1.6;
        final to = radarR * 0.72;
        final r = from + (to - from) * t;
        final pos = c + Offset(math.cos(a), math.sin(a)) * r;
        canvas.drawCircle(pos, 2.2 * (1 - t * 0.6), shardPaint);
      }

      // the shield itself (elastic settle handled by scale)
      _drawShield(canvas, c, t, breathe);
    }
  }

  void _drawShield(Canvas canvas, Offset c, double t, double breathe) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(breathe, breathe);

    // gold disc behind
    canvas.drawCircle(
      Offset.zero,
      58,
      Paint()..color = gold.withValues(alpha: 0.10 * t),
    );
    canvas.drawCircle(
      Offset.zero,
      58,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = gold.withValues(alpha: 0.3 * t),
    );

    // shield path
    final shield = Path()
      ..moveTo(0, -40)
      ..lineTo(33, -29)
      ..lineTo(33, -2)
      ..quadraticBezierTo(33, 26, 0, 38)
      ..quadraticBezierTo(-33, 26, -33, -2)
      ..lineTo(-33, -29)
      ..close();

    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.fill
        ..color = gold.withValues(alpha: t),
    );

    // inner crest
    final crest = Path()
      ..moveTo(0, -29)
      ..lineTo(23, -21)
      ..lineTo(23, -2)
      ..quadraticBezierTo(23, 18, 0, 27)
      ..quadraticBezierTo(-23, 18, -23, -2)
      ..lineTo(-23, -21)
      ..close();
    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.fill
        ..color = espresso.withValues(alpha: t * 0.92),
    );

    // family dots inside the crest (one per child, watching over)
    const familyDots = [
      Offset(0, 0),
      Offset(-9, -7),
      Offset(9, -7),
    ];
    for (final dot in familyDots) {
      canvas.drawCircle(
        dot,
        3,
        Paint()..color = gold.withValues(alpha: t),
      );
    }

    // gold check settled at center
    final check = Path()
      ..moveTo(-5, 0)
      ..lineTo(-1.5, 3.5)
      ..lineTo(6, -4);
    canvas.drawPath(
      check,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = cream.withValues(alpha: t),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GuardianScanPainter old) =>
      old.sweep != sweep ||
      old.radarFade != radarFade ||
      old.blips != blips ||
      old.shieldIn != shieldIn ||
      old.breathe != breathe;
}