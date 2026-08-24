import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Opening intro — a vigilant golden eye opens on espresso, glows,
/// then closes into the family shield while the wordmark settles in.
/// Nazar = "sight", so the eye is the brand's watchful guardian.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Element curves, staged on one timeline
  late final Animation<double> _ripple;
  late final Animation<double> _eyeOpen;
  late final Animation<double> _blink;
  late final Animation<double> _eyeIn;
  late final Animation<double> _eyeOut;
  late final Animation<double> _shieldIn;
  late final Animation<double> _shieldScale;
  late final Animation<double> _overlineIn;
  late final Animation<double> _wordIn;
  late final Animation<double> _footerIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // 1. Expanding gold ripple
    _ripple = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );

    // 2. Eyelids part open (watchful)
    _eyeOpen = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    );

    // 2b. One slow blink while open — close, hold a beat, reopen.
    //     A single dip 1 → 0.04 → 1 with a tiny dwell at the bottom.
    _blink = TweenSequence<double>([
      // hold wide open a moment
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 22),
      // close down
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.04)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 14,
      ),
      // dwell (fully shut — the mascot "nods")
      TweenSequenceItem(tween: ConstantTween(0.04), weight: 10),
      // reopen
      TweenSequenceItem(
        tween: Tween(begin: 0.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 18,
      ),
      // hold open as the shield lands
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 36),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );

    // 3. Eye fades in, then out before the shield lands
    _eyeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.45, curve: Curves.easeIn),
    );
    _eyeOut = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.72, 0.9, curve: Curves.easeIn),
    );

    // 4. Shield drops in over the closing eye
    _shieldIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.74, 0.9, curve: Curves.easeIn),
    );
    _shieldScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.72, 1.0, curve: Curves.elasticOut),
    );

    // 5. Staggered text
    _overlineIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.82, 0.95, curve: Curves.easeOut),
    );
    _wordIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.86, 1.0, curve: Curves.easeOutCubic),
    );
    _footerIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.92, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3300), _checkAndNavigate);
  }

  Future<void> _checkAndNavigate() async {
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final role = prefs.getString('role');
    final childId = prefs.getString('child_id');

    if (session != null && role == 'parent') {
      context.go('/main');
    } else if (role == 'child' && childId != null) {
      context.go('/active');
    } else {
      context.go('/role-select');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNewUser =
        Supabase.instance.client.auth.currentSession == null;

    return Scaffold(
      backgroundColor: AppColors.espresso,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle dotted texture over the espresso
          CustomPaint(painter: _DotTexturePainter()),

          // ─── Content ─────────────────────────────────
          Column(
            children: [
              const Spacer(flex: 3),

              // Eye / Shield stage
              SizedBox(
                height: 190,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      // Ripple always runs first
                      return SizedBox(
                        width: 190,
                        height: 190,
                        child: CustomPaint(
                          painter: _NazarEyePainter(
                            open: _eyeOpen.value * _blink.value,
                            alpha: _eyeIn.value * (1 - _eyeOut.value),
                            ripple: _ripple.value,
                            gold: AppColors.primary,
                            cream: AppColors.buttonPrimaryText,
                            espresso: AppColors.espresso,
                          ),
                          foregroundPainter: _ShieldPainter(
                            t: _shieldIn.value,
                            scale: 1.45 - 0.45 * _shieldScale.value,
                            gold: AppColors.primary,
                            espresso: AppColors.espresso,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 34),

              // Overline
              FadeTransition(
                opacity: _overlineIn,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_overlineIn),
                  child: Text(
                    'PROTECTING YOUR FAMILY',
                    style: AppTheme.overline(11, letterSpacing: 3.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Serif wordmark
              FadeTransition(
                opacity: _wordIn,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_wordIn),
                  child: const Text(
                    'Nazar.Ai',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.buttonPrimaryText,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // Footer brand
              FadeTransition(
                opacity: _footerIn,
                child: Text(
                  isNewUser ? 'SIGN IN · PROTECT · WATCH OVER' : 'NAZAR.AI',
                  style: AppTheme.overline(10, letterSpacing: 4),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── The watchful eye ─────────────────────────────────
class _NazarEyePainter extends CustomPainter {
  final double open; // 0 = shut, 1 = wide
  final double alpha; // overall visibility
  final double ripple; // 0 → 1 ring expansion
  final Color gold;
  final Color cream;
  final Color espresso;

  _NazarEyePainter({
    required this.open,
    required this.alpha,
    required this.ripple,
    required this.gold,
    required this.cream,
    required this.espresso,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);

    // ─── Expanding gold ripple ────────────────────────
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = gold.withValues(alpha: (1 - ripple) * 0.55);
    canvas.drawCircle(c, 44 + 150 * ripple, ripplePaint);
    if (ripple > 0.5) {
      final second = (ripple - 0.5) * 2;
      canvas.drawCircle(
        c,
        44 + 150 * second,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = gold.withValues(alpha: (1 - second) * 0.3),
      );
    }

    if (alpha <= 0.02) return;

    // ─── Sclera (cream almond) ────────────────────────
    const scleraW = 168.0, scleraH = 92.0;
    final scleraRect = Rect.fromCenter(
      center: c,
      width: scleraW,
      height: scleraH,
    );
    canvas.drawOval(scleraRect, Paint()..color = cream.withValues(alpha: alpha));

    // ─── Iris (gold) ──────────────────────────────────
    const irisR = 34.0;
    canvas.drawCircle(
      c,
      irisR,
      Paint()..color = gold.withValues(alpha: alpha),
    );
    // iris detail ring
    canvas.drawCircle(
      c,
      irisR * 0.72,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = gold
            .withValues(alpha: alpha * 0.35),
    );

    // ─── Pupil ────────────────────────────────────────
    canvas.drawCircle(
      c,
      14,
      Paint()..color = espresso.withValues(alpha: alpha),
    );

    // catchlight
    canvas.drawCircle(
      c + const Offset(8, -8),
      4.5,
      Paint()..color = Colors.white.withValues(alpha: alpha * 0.9),
    );

    // ─── Eyelids (espresso curtains with gold lash line)
    final travel = (1 - open) * (scleraH / 2 + 26);
    const lidW = scleraW / 2 + 12;

    // top lid
    canvas.drawRect(
      Rect.fromLTRB(
        c.dx - lidW,
        c.dy - scleraH / 2 - 26,
        c.dx + lidW,
        c.dy - scleraH / 2 - 26 + travel,
      ),
      Paint()..color = espresso,
    );
    // bottom lid
    canvas.drawRect(
      Rect.fromLTRB(
        c.dx - lidW,
        c.dy + scleraH / 2 + 26 - travel,
        c.dx + lidW,
        c.dy + scleraH / 2 + 26,
      ),
      Paint()..color = espresso,
    );

    // gold lash edges
    if (open > 0.03) {
      final lash = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = gold.withValues(alpha: open.clamp(0.0, 1.0) * 0.85);
      canvas.drawLine(
        Offset(c.dx - scleraW / 2, c.dy - scleraH / 2 - 26 + travel),
        Offset(c.dx + scleraW / 2, c.dy - scleraH / 2 - 26 + travel),
        lash,
      );
      canvas.drawLine(
        Offset(c.dx - scleraW / 2, c.dy + scleraH / 2 + 26 - travel),
        Offset(c.dx + scleraW / 2, c.dy + scleraH / 2 + 26 - travel),
        lash,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NazarEyePainter old) =>
      old.open != open || old.alpha != alpha || old.ripple != ripple;
}

// ─── Shield that drops in as the eye closes ───────────
class _ShieldPainter extends CustomPainter {
  final double t; // 0 → 1 reveal
  final double scale;
  final Color gold;
  final Color espresso;

  _ShieldPainter({
    required this.t,
    required this.scale,
    required this.gold,
    required this.espresso,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0.01) return;

    final c = size.center(Offset.zero);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(scale, scale);
    canvas.translate(-c.dx, -c.dy);

    // soft gold halo
    final halo = Paint()..color = gold.withValues(alpha: 0.12 * t);
    canvas.drawCircle(c, 92, halo);
    canvas.drawCircle(c, 92, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = gold.withValues(alpha: 0.35 * t));

    // gold-tinted disc behind the shield
    canvas.drawCircle(
      c,
      64,
      Paint()..color = gold.withValues(alpha: 0.12 * t),
    );

    // ─── Shield path ──────────────────────────────────
    final shield = Path()
      ..moveTo(0, -46)
      ..lineTo(38, -34)
      ..lineTo(38, -2)
      ..quadraticBezierTo(38, 30, 0, 44)
      ..quadraticBezierTo(-38, 30, -38, -2)
      ..lineTo(-38, -34)
      ..close();

    // face (gold)
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.fill
        ..color = gold.withValues(alpha: t),
    );

    // inner crest line
    final crest = Path()
      ..moveTo(0, -33)
      ..lineTo(26, -24)
      ..lineTo(26, -2)
      ..quadraticBezierTo(26, 22, 0, 32)
      ..quadraticBezierTo(-26, 22, -26, -2)
      ..lineTo(-26, -24)
      ..close();
    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = espresso.withValues(alpha: t),
    );

    // small crest fill on the shield
    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.fill
        ..color = espresso.withValues(alpha: t * 0.92),
    );

    // simple watchful "eye" mark inside the crest
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 0), width: 18, height: 10),
      Paint()..color = gold.withValues(alpha: t),
    );
    canvas.drawCircle(
      const Offset(0, 0),
      3,
      Paint()..color = espresso.withValues(alpha: t),
    );

    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter old) =>
      old.t != t || old.scale != scale;
}

// ─── Dotted texture over espresso ─────────────────────
class _DotTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF241A12).withValues(alpha: 0.25);
    const gap = 26.0;
    for (double y = 10; y < size.height; y += gap) {
      for (double x = 10; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}