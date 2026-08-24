import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/detection.dart';
import '../../models/child.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Detection> _detections = [];
  List<Child> _children = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final childrenRes = await Supabase.instance.client
          .from('children')
          .select()
          .eq('parent_id', user.id);
      _children =
          (childrenRes as List).map((j) => Child.fromJson(j)).toList();

      if (_children.isNotEmpty) {
        final ids = _children.map((c) => c.id).toList();
        final detRes = await Supabase.instance.client
            .from('detections')
            .select()
            .inFilter('child_id', ids)
            .order('created_at', ascending: false);
        _detections =
            (detRes as List).map((j) => Detection.fromJson(j)).toList();
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  int get _todayCount {
    final now = DateTime.now();
    return _detections.where((d) {
      final local = d.createdAt.toLocal();
      return local.year == now.year &&
          local.month == now.month &&
          local.day == now.day;
    }).length;
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  String _detectionTitle(String by) {
    switch (by) {
      case 'ocr':
        return 'Gambling Text Detected';
      case 'mobilenet':
        return 'Gambling Visual Detected';
      case 'trustpositif':
        return 'Gambling URL Detected';
      case 'combined':
        return 'Gambling Detected';
      default:
        return 'Suspicious Content';
    }
  }

  Child _childOf(Detection d) {
    return _children.firstWhere(
      (c) => c.id == d.childId,
      orElse: () => Child(
        id: '',
        parentId: '',
        childName: 'Child',
        age: 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ─── Espresso header ───────────────────
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
                          Text(
                            'ACTIVITY LOG',
                            style: AppTheme.overline(11),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'What Nazar.Ai caught',
                            style: AppTheme.serif(
                              26,
                              color: AppColors.buttonPrimaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Summary strip ─────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            _SummaryItem(
                              value: '${_detections.length}',
                              label: 'ALL TIME',
                              color: AppColors.danger,
                            ),
                            _SummaryItem(
                              value: '$_todayCount',
                              label: 'TODAY',
                              color: AppColors.warning,
                            ),
                            _SummaryItem(
                              value: '${_children.length}',
                              label: 'DEVICES',
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ─── List ──────────────────────────────
                  if (_detections.isEmpty)
                    const SliverToBoxAdapter(child: _EmptyActivity())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      sliver: SliverList.separated(
                        itemCount: _detections.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final d = _detections[index];
                          final child = _childOf(d);
                          return _ActivityTile(
                            detection: d,
                            child: child,
                            title: _detectionTitle(d.triggeredBy),
                            timeAgo: _timeAgo(d.createdAt),
                            onTap: () => context.push('/detail/${d.id}'),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _SummaryItem(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Detection detection;
  final Child child;
  final String title;
  final String timeAgo;
  final VoidCallback onTap;

  const _ActivityTile({
    required this.detection,
    required this.child,
    required this.title,
    required this.timeAgo,
    required this.onTap,
  });

  String get _firstName => child.childName.split(' ').first;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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
          children: [
            // Icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.danger,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        _firstName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          detection.confidencePercent,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Text('🛡️', style: TextStyle(fontSize: 56)),
          SizedBox(height: 12),
          Text(
            'Nothing flagged yet',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Every detection Nazar.Ai makes will\nshow up here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}