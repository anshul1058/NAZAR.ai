import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  String? _selectedRole;

  void _selectRole(String role) {
    HapticFeedback.lightImpact();
    setState(() => _selectedRole = role);
  }

  void _continue() {
    if (_selectedRole == null) return;
    HapticFeedback.mediumImpact();

    if (_selectedRole == 'parent') {
      context.push('/login');
    } else {
      context.push('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.espresso,
      body: Stack(
        children: [
          // Subtle dotted texture over the espresso
          Positioned.fill(
            child: CustomPaint(
              painter: _DotTexturePainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Header ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                  child: Column(
                    children: [
                      Text(
                        'NAZAR.AI',
                        style: AppTheme.overline(11, letterSpacing: 3.5),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Who are you?',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.buttonPrimaryText,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Select your role to set up the\ndashboard or link a device.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.buttonPrimaryText
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Shield badge ─────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                ),

                // ─── Role cards ──────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoleOption(
                          image: 'assets/images/orangtua.png',
                          icon: Icons.family_restroom_rounded,
                          label: 'Parent',
                          subtitle: 'Monitor your little one',
                          isSelected: _selectedRole == 'parent',
                          onTap: () => _selectRole('parent'),
                        ),
                        const SizedBox(height: 16),
                        _RoleOption(
                          image: 'assets/images/anak.png',
                          icon: Icons.child_care_rounded,
                          label: 'Child',
                          subtitle: "Scan your parent's QR",
                          isSelected: _selectedRole == 'child',
                          onTap: () => _selectRole('child'),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Parchment footer bar ────────────────
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _selectedRole == null ? null : _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          foregroundColor: AppColors.buttonPrimaryText,
                          disabledBackgroundColor: AppColors.toggleOff,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                                color: _selectedRole == null
                                    ? AppColors.textMuted
                                    : AppColors.buttonPrimaryText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: _selectedRole == null
                                  ? AppColors.textMuted
                                  : AppColors.buttonPrimaryText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Role Option Card ─────────────────────────────────
class _RoleOption extends StatelessWidget {
  final String image;
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.image,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF241A12),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: Row(
          children: [
            // Avatar circle with icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : const Color(0xFF241A12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : Colors.transparent,
                ),
              ),
              child: Image.asset(
                image,
                width: 36,
                height: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.buttonPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.buttonPrimaryText
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Selection circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.buttonPrimaryText.withValues(alpha: 0.25),
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.espresso,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
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