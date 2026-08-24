import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Shield — a safety & awareness hub for parents.
/// Educational resources, quick guidance, and warning signs about online gambling.
class ShieldScreen extends StatefulWidget {
  const ShieldScreen({super.key});

  @override
  State<ShieldScreen> createState() => _ShieldScreenState();
}

class _ShieldScreenState extends State<ShieldScreen> {
  final _topics = const [
    _ShieldTopic(
      icon: Icons.workspace_premium_rounded,
      tint: AppColors.primary,
      title: 'What is online gambling?',
      body:
          'Slot apps, betting sites, and "jackpot" games disguised as fun. '
          'Nazar.Ai watches for these automatically.',
    ),
    _ShieldTopic(
      icon: Icons.visibility_rounded,
      tint: AppColors.danger,
      title: 'Early warning signs',
      body:
          'Sudden mood swings, secretive phone use, borrowing money, or '
          'obsessing over "winning". Spot them before it deepens.',
    ),
    _ShieldTopic(
      icon: Icons.lock_rounded,
      tint: AppColors.success,
      title: 'Lock it down',
      body:
          'Turn off in-app purchases, use parental controls, and keep '
          'payments under your watch. Small steps add up.',
    ),
    _ShieldTopic(
      icon: Icons.forum_rounded,
      tint: AppColors.warning,
      title: 'Talk, don\'t punish',
      body:
          'Kids hide things they fear. Talk calmly, explain the risks, and '
          'let Nazar.Ai be the shield — not the enemy.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ─── Espresso hero ────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: AppColors.espresso,
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 16,
                20,
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SHIELD', style: AppTheme.overline(11)),
                  const SizedBox(height: 6),
                  Text(
                    'The Shield',
                    style: AppTheme.serif(
                      26,
                      color: AppColors.buttonPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Simple tools to keep them off gambling — and on your side.',
                    style: TextStyle(
                      color: AppColors.buttonPrimaryText
                          .withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Topic cards ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverList.separated(
              itemCount: _topics.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return _TopicCard(topic: topic, index: index);
              },
            ),
          ),

          // ─── Emergency banner ─────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.health_and_safety_rounded,
                      color: AppColors.danger,
                      size: 26,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need help right now?',
                            style: AppTheme.serif(
                              16,
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Gambling addiction is treatable. Reach a free '
                            'helpline, or talk to a counselor you trust.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => context.push('/education'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: BorderSide(
                                color: AppColors.danger.withValues(alpha: 0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Open safety guide',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Topic Card ───────────────────────────────────────
class _TopicCard extends StatelessWidget {
  final _ShieldTopic topic;
  final int index;

  const _TopicCard({required this.topic, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: topic.tint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(topic.icon, color: topic.tint, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: AppTheme.serif(15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _ShieldTopic {
  final IconData icon;
  final Color tint;
  final String title;
  final String body;

  const _ShieldTopic({
    required this.icon,
    required this.tint,
    required this.title,
    required this.body,
  });
}