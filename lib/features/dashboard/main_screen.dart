import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'activity_screen.dart';
import 'shield_screen.dart';
import 'family_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ActivityScreen(),
    const ShieldScreen(),
    const FamilyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentIndex = index);
        },
        onAddTap: () {
          HapticFeedback.mediumImpact();
          context.push('/add-child');
        },
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.espresso,
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Dashboard (left)
              Expanded(
                child: _NavItem(
                  icon: Icons.dashboard_outlined,
                  iconActive: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),

              // Activity (left-center)
              Expanded(
                child: _NavItem(
                  icon: Icons.history_rounded,
                  iconActive: Icons.history_rounded,
                  label: 'Activity',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),

              // Plus button (center)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.buttonPrimaryText.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 28,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.espresso,
                      size: 30,
                    ),
                  ),
                ),
              ),

              // Shield (right-center)
              Expanded(
                child: _NavItem(
                  icon: Icons.shield_outlined,
                  iconActive: Icons.shield_rounded,
                  label: 'Shield',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),

              // Family (right)
              Expanded(
                child: _NavItem(
                  icon: Icons.family_restroom_rounded,
                  iconActive: Icons.family_restroom_rounded,
                  label: 'Family',
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? iconActive : icon,
                key: ValueKey(isActive),
                color: isActive
                    ? AppColors.primary
                    : AppColors.navInactive,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.navInactive,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
