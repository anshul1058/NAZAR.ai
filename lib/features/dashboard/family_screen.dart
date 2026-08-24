import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/child.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
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
      final res = await Supabase.instance.client
          .from('children')
          .select()
          .eq('parent_id', user.id)
          .order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _children = (res as List).map((j) => Child.fromJson(j)).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  int get _onlineCount =>
      _children.where((c) => c.effectiveStatus == ConnectionStatus.online)
          .length;

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
                            'FAMILY',
                            style: AppTheme.overline(11),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'My Family',
                            style: AppTheme.serif(
                              26,
                              color: AppColors.buttonPrimaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _children.isEmpty
                                ? 'No devices connected yet'
                                : '$_onlineCount of ${_children.length} online right now',
                            style: TextStyle(
                              color: AppColors.buttonPrimaryText
                                  .withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Children list ─────────────────────
                  if (_children.isEmpty)
                    const SliverToBoxAdapter(child: _EmptyFamily())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverList.separated(
                        itemCount: _children.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final child = _children[index];
                          return _FamilyTile(
                            child: child,
                            onTap: () =>
                                context.push('/child/${child.id}', extra: child),
                          );
                        },
                      ),
                    ),

                  // ─── Add child button ──────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await context.push('/add-child');
                          _loadData();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          foregroundColor: AppColors.primary,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text(
                          'Add a Child',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─── Family Tile ──────────────────────────────────────
class _FamilyTile extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;
  const _FamilyTile({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (child.effectiveStatus) {
      ConnectionStatus.online => AppColors.success,
      ConnectionStatus.offlineInternet => AppColors.danger,
      ConnectionStatus.offlineManual => AppColors.warning,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            // Avatar with status ring
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                      width: 2.5,
                    ),
                  ),
                  child: child.avatarUrl != null && child.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            child.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _InitialAvatar(
                                name: child.firstName),
                          ),
                        )
                      : _InitialAvatar(name: child.firstName),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: child.effectiveStatus ==
                            ConnectionStatus.offlineManual
                        ? const Icon(Icons.link_off_rounded,
                            color: Colors.white, size: 8)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.childName,
                    style: AppTheme.serif(16, weight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${child.age} years old',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Status pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                child.effectiveStatus == ConnectionStatus.online
                    ? 'Online'
                    : 'Offline',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;
  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'PlayfairDisplay',
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────
class _EmptyFamily extends StatelessWidget {
  const _EmptyFamily();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Text('👦', style: TextStyle(fontSize: 56)),
          SizedBox(height: 12),
          Text(
            'No devices connected',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Add a child\'s phone to start protecting\nyour family',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}