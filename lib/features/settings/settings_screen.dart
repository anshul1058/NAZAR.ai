import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/language_provider.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../models/child.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  bool _isLoading = true;
  List<Child> _children = [];
  String _userName = '';
  String _userEmail = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      context.go('/login');
      return;
    }

    // Set from auth first without waiting for the DB
    setState(() {
      _userName = user.userMetadata?['full_name'] ?? '';
      _userEmail = user.email ?? '';
    });

    // Fetch children — must succeed
    try {
      final childrenRes = await Supabase.instance.client
          .from('children')
          .select()
          .eq('parent_id', user.id)
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _children = (childrenRes as List)
            .map((j) => Child.fromJson(j as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.d('settings children error → $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }

    // Fetch avatar — optional, failure is fine
    try {
      final parentRes = await Supabase.instance.client
          .from('parents')
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;
      setState(() {
        _avatarUrl = (parentRes as Map?)?['avatar_url'] ?? '';
      });
    } catch (e) {
      AppLogger.d('settings avatar error → $e');
    }
  }

  Future<void> _logout() async {
    final loc = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(loc.readyToLogout,
            style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        content: Text(
          loc.logoutMessage,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.logout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Supabase.instance.client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('role');
      if (!mounted) return;
      context.go('/role-select');
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(languageProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).language,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = supportedLocales[index];
                  final name =
                      languageDisplayNames[locale.languageCode] ?? locale.languageCode;
                  final isSelected =
                      locale.languageCode == currentLocale.languageCode;
                  return ListTile(
                    leading: isSelected
                        ? Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: AppColors.primary, size: 18),
                          )
                        : const SizedBox(width: 32),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      ref.read(languageProvider.notifier).setLanguage(locale);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmUnpair(Child child) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Unlink ${child.childName}? 🤔",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          "${child.childName}'s phone won't be monitored anymore.",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from('children')
            .delete()
            .eq('id', child.id);
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${child.childName}'s phone has been unlinked"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Failed to unlink, try again?'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // ← settings is a tab, not a push
        title: const Text(
          AppStrings.settingsTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                AppStrings.appName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Profile Card ───────────────────
                    _ProfileCard(
                      userName: _userName,
                      userEmail: _userEmail,
                      avatarUrl: _avatarUrl,
                      onEditTap: () async {
                        await context.push('/edit-profile');
                        _loadData();
                      },
                    ),
                    const SizedBox(height: 24),

                    // ─── Child Devices ─────────────────
                    const _SectionHeader(title: AppStrings.connectedDevices),
                    const SizedBox(height: 12),
                    _children.isEmpty
                        ? _EmptyChildren()
                        : Column(
                            children: _children
                                .map((child) => _ChildTile(
                                      child: child,
                                      onUnpair: () => _confirmUnpair(child),
                                    ))
                                .toList(),
                          ),
                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () async {
                        await context.push('/add-child');
                        _loadData(); // refresh after adding a child
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add_rounded,
                          color: AppColors.textPrimary),
                      label: Text(AppLocalizations.of(context).addNewChild,
                          style: const TextStyle(color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 24),

                    // ─── Notification ─────────────────────
                    _SectionHeader(title: AppLocalizations.of(context).notifications),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: AppLocalizations.of(context).notifications,
                      subtitle: AppLocalizations.of(context).notificationDesc,
                      trailing: Switch(
                        value: _notificationEnabled,
                        activeColor: AppColors.success,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() => _notificationEnabled = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ─── Language ──────────────────────
                    _SectionHeader(title: AppLocalizations.of(context).language),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, _) {
                        final currentLocale = ref.watch(languageProvider);
                        final currentName =
                            languageDisplayNames[currentLocale.languageCode] ??
                                'English';
                        return _SettingsTile(
                          icon: Icons.language_rounded,
                          title: AppLocalizations.of(context).language,
                          subtitle: currentName,
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textSecondary),
                          onTap: () => _showLanguagePicker(context, ref),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ─── About ────────────────────────
                    _SectionHeader(title: AppLocalizations.of(context).about),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.shield_rounded,
                      title: AppLocalizations.of(context).appName,
                      subtitle: AppLocalizations.of(context).version,
                    ),
                    const SizedBox(height: 4),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: AppLocalizations.of(context).madeWith,
                      subtitle: AppLocalizations.of(context).protectingKids,
                    ),
                    const SizedBox(height: 32),

                    // ─── Logout ─────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(
                          AppLocalizations.of(context).logout,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────
class _ProfileCard extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String avatarUrl;
  final VoidCallback onEditTap;

  const _ProfileCard({
    required this.userName,
    required this.userEmail,
    required this.avatarUrl,
    required this.onEditTap,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  bool _isUploading = false;
  String? _localAvatarUrl;

  Future<void> _pickAndUploadPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).chooseProfilePhoto,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.primary),
              ),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library_rounded,
                    color: AppColors.primary),
              ),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final bytes = await picked.readAsBytes();
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 256,
        minHeight: 256,
        quality: 60,
        format: CompressFormat.jpeg,
      );

      final filePath = '${user.id}/profile.jpg';
      await Supabase.instance.client.storage.from('avatars').uploadBinary(
            filePath,
            compressedBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final url = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(filePath);

      await Supabase.instance.client
          .from('parents')
          .update({'avatar_url': url}).eq('id', user.id);

      setState(() => _localAvatarUrl = url);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Profile photo updated successfully! ✅'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload photo: $e'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayUrl = _localAvatarUrl ?? widget.avatarUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar + pencil
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: _isUploading
                    ? const Center(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primary),
                        ),
                      )
                    : displayUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              displayUrl,
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  widget.userName.isNotEmpty
                                      ? widget.userName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              widget.userName.isNotEmpty
                                  ? widget.userName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
              ),

              // Pencil at bottom left
              Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onTap: _isUploading ? null : _pickAndUploadPhoto,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: AppColors.buttonPrimaryText, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            widget.userName.isNotEmpty ? widget.userName : 'Name not set',
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          Text(
            widget.userEmail,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: widget.onEditTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                AppLocalizations.of(context).editAccountDetails,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTheme.serif(16, weight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ─── Child Tile ───────────────────────────────────────
class _ChildTile extends StatelessWidget {
  final Child child;
  final VoidCallback onUnpair;

  const _ChildTile({required this.child, required this.onUnpair});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Child avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: child.avatarUrl != null && child.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      child.avatarUrl!,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          child.childName[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      child.childName[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child.childName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${child.age} ${AppLocalizations.of(context).yearsOld}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(AppLocalizations.of(context).activeStatus,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(Icons.link_off_rounded,
                color: AppColors.danger, size: 20),
            onPressed: onUnpair,
          ),
        ],
      ),
    );
  }
}

// ─── Settings Tile ────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
      ),
    );
  }
}

// ─── Empty Children ───────────────────────────────────
class _EmptyChildren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text('👦', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context).noChildrenConnected,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context).addChildFirst,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
