import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_logger.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({super.key});

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _childId = '';
  String _parentName = '';

  @override
  void initState() {
    super.initState();
    _loadData();

    // Mascot bobbing animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getString('child_id') ?? '';

    if (childId.isEmpty) return;

    // Get the parent name via RPC (the kid's phone is anonymous — can't SELECT
    // the table directly because RLS blocks it; get_pairing_info is SECURITY
    // DEFINER).
    String parentName = '';
    try {
      final res = await Supabase.instance.client
          .rpc('get_pairing_info', params: {'p_child_id': childId});

      if (res is List && res.isNotEmpty) {
        parentName = (res.first as Map)['parent_name'] as String? ?? '';
      }
    } catch (e) {
      AppLogger.d('Failed to get pairing info → $e');
    }

    if (!mounted) return;
    setState(() {
      _childId = childId;
      _parentName = parentName;
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
      backgroundColor: AppColors.espresso,

      // Can't go back with the phone's back button
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Animated mascot
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/maskot.png',
                    width: 160,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 28),

                // Status text
                const Text(
                  AppStrings.serviceActive,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    color: AppColors.buttonPrimaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  _parentName.isNotEmpty
                      ? 'Connected with $_parentName.\nNazar.Ai is running in the background.'
                      : 'Nazar.Ai is running in the background.',
                  style: TextStyle(
                    color: AppColors.buttonPrimaryText.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Info box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimaryText.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.buttonPrimaryText.withValues(alpha: 0.12),
                    ),
                  ),
                  child: const Column(
                    children: [
                      _InfoItem(
                        icon: Icons.visibility_outlined,
                        text: 'Your screen is scanned periodically',
                      ),
                      SizedBox(height: 16),
                      _InfoItem(
                        icon: Icons.notifications_outlined,
                        text:
                            'Your parents are notified right away if there is any suspicious activity',
                      ),
                      SizedBox(height: 16),
                      _InfoItem(
                        icon: Icons.lock_outline_rounded,
                        text: 'Your data is safe and can only be seen by your parents',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Connected ID
                if (_childId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimaryText.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          color: AppColors.buttonPrimaryText,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _parentName.isNotEmpty
                              ? 'Connected with $_parentName'
                              : 'Connected',
                          style: TextStyle(
                            color: AppColors.buttonPrimaryText
                                .withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Info Item ────────────────────────────────────────
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.buttonPrimaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.buttonPrimaryText.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
