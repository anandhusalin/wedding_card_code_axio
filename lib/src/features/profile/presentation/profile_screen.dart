import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../auth/domain/user_model.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../wedding/presentation/wedding_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authControllerProvider);
    final weddingsState = ref.watch(weddingListControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final user = userState.valueOrNull;

    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          ref.invalidate(authControllerProvider);
          ref.invalidate(weddingListControllerProvider);
          await Future<void>.delayed(const Duration(milliseconds: 300));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _ProfileHeader(user: user, isDark: isDark),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.pagePadding(context),
                vertical: AppTheme.space4,
              ),
              sliver: SliverList.list(
                children: [
                  if (user == null)
                    _UserLoadingCard()
                  else
                    _AccountSummaryCard(user: user)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.05),
                  const SizedBox(height: AppTheme.space4),

                  // ─── Stats row ─────────────────────────────
                  _StatsRow(state: weddingsState, isDark: isDark)
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.05),
                  const SizedBox(height: AppTheme.space6),

                  // ─── Plan card ─────────────────────────────
                  _PlanCard(
                    plan: user?.plan ?? 'free',
                    totalWeddings: weddingsState.valueOrNull?.length ?? 0,
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.05),
                  const SizedBox(height: AppTheme.space6),

                  // ─── Settings list ─────────────────────────
                  _SectionTitle('Preferences'),
                  const SizedBox(height: AppTheme.space2),
                  _SettingsList(
                    children: [
                      _SettingTile(
                        icon: Icons.translate_rounded,
                        iconColor: AppColors.secondary,
                        title: 'Language',
                        subtitle: locale.languageCode == 'en'
                            ? 'English'
                            : 'മലയാളം (Malayalam)',
                        trailing: Switch(
                          value: locale.languageCode == 'ml',
                          onChanged: (_) => ref
                              .read(localeControllerProvider.notifier)
                              .toggleLocale(),
                        ),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.brightness_6_rounded,
                        iconColor: AppColors.tertiary,
                        title: 'Theme',
                        subtitle: 'System default',
                        onTap: () => _showThemeChooser(context),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.notifications_active_rounded,
                        iconColor: AppColors.info,
                        title: 'Notifications',
                        subtitle: 'Manage push & email',
                        onTap: () => _showComingSoon(context, 'Notifications'),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.shield_outlined,
                        iconColor: AppColors.success,
                        title: 'Privacy & Security',
                        subtitle: 'Password, sessions, data export',
                        onTap: () => _showComingSoon(context, 'Privacy'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: AppTheme.space6),

                  _SectionTitle('Support'),
                  const SizedBox(height: AppTheme.space2),
                  _SettingsList(
                    children: [
                      _SettingTile(
                        icon: Icons.help_outline_rounded,
                        iconColor: AppColors.primary,
                        title: 'Help & FAQ',
                        onTap: () => _showComingSoon(context, 'Help & FAQ'),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        iconColor: AppColors.secondary,
                        title: 'Send feedback',
                        onTap: () => _showComingSoon(context, 'Feedback'),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.description_outlined,
                        iconColor: AppColors.slate500,
                        title: 'Terms of service',
                        onTap: () => _showComingSoon(context, 'Terms'),
                      ),
                      const _SettingDivider(),
                      _SettingTile(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: AppColors.slate500,
                        title: 'Privacy policy',
                        onTap: () => _showComingSoon(context, 'Privacy policy'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: AppTheme.space8),

                  // ─── Logout ────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoggingOut ? null : _confirmAndLogout,
                      icon: _isLoggingOut
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.logout_rounded),
                      label: Text(_isLoggingOut ? 'Signing out…' : 'Sign out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms),
                  const SizedBox(height: AppTheme.space2),
                  Center(
                    child: Text(
                      'Wedding Cards v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.space8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to manage your weddings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _isLoggingOut = true);
    HapticFeedback.lightImpact();
    try {
      await ref.read(authControllerProvider.notifier).logout();
      if (mounted) context.go('/login');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not sign out: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showThemeChooser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto_rounded),
              title: const Text('System default'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode_rounded),
              title: const Text('Light'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════

class _ProfileHeader extends StatelessWidget {
  final User? user;
  final bool isDark;
  const _ProfileHeader({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName ?? 'Guest';
    final email = user?.email ?? '';
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF4C0519), Color(0xFF2E1065)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.brandGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.pagePadding(context),
              AppTheme.space4,
              Responsive.pagePadding(context),
              AppTheme.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppTheme.space4),
                Row(
                  children: [
                    // Avatar with gradient ring
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.primarySurface,
                        backgroundImage: (user?.avatarUrl != null)
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: (user?.avatarUrl == null)
                            ? Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// ACCOUNT SUMMARY
// ═══════════════════════════════════════════════════════════════════

class _AccountSummaryCard extends ConsumerWidget {
  final User user;
  const _AccountSummaryCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberSince = user.email.isNotEmpty
        ? 'Member since ${DateFormat.yMMM().format(DateTime.now())}'
        : '';

    return Container(
      padding: const EdgeInsets.all(AppTheme.space5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondarySurface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: AppColors.secondary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (memberSince.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    memberSince,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STATS ROW
// ═══════════════════════════════════════════════════════════════════

class _StatsRow extends StatelessWidget {
  final AsyncValue state;
  final bool isDark;
  const _StatsRow({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (weddings) {
        final list = weddings as List;
        final total = list.length;
        final published = list.where((w) => w.isPublished == true).length;
        final drafts = total - published;
        final views = list.fold<int>(0, (sum, w) => sum + (w.viewCount as int));

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _StatCell(label: 'Total', value: '$total', color: AppColors.primary),
                _StatCell(label: 'Published', value: '$published', color: AppColors.success),
                _StatCell(label: 'Drafts', value: '$drafts', color: AppColors.tertiary),
                _StatCell(label: 'Views', value: '$views', color: AppColors.secondary),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, _) => Container(
        padding: const EdgeInsets.all(AppTheme.space4),
        decoration: BoxDecoration(
          color: AppColors.errorSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
            const SizedBox(width: AppTheme.space2),
            Expanded(
              child: Text(
                'Couldn\'t load stats',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCell({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// PLAN CARD
// ═══════════════════════════════════════════════════════════════════

class _PlanCard extends StatelessWidget {
  final String plan;
  final int totalWeddings;
  const _PlanCard({required this.plan, required this.totalWeddings});

  @override
  Widget build(BuildContext context) {
    final isPro = plan == 'pro' || plan == 'premium';
    final isFree = !isPro;
    final remaining = isFree ? (3 - totalWeddings).clamp(0, 99) : null;
    final usedPercent = isFree
        ? (totalWeddings / 3).clamp(0.0, 1.0)
        : null;

    return Container(
      padding: const EdgeInsets.all(AppTheme.space5),
      decoration: BoxDecoration(
        gradient: isPro ? AppColors.brandGradient : null,
        color: isPro
            ? null
            : (Theme.of(context).brightness == Brightness.dark
                ? AppColors.slate900
                : AppColors.slate50),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: isPro
            ? null
            : Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPro
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  isPro ? 'PRO' : 'FREE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPro ? Colors.white : AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (isPro)
                const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 20)
              else
                Icon(Icons.workspace_premium_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20),
            ],
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            isPro ? 'Pro plan' : 'Free plan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isPro
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPro
                ? 'Unlimited wedding sites, premium templates, custom domain.'
                : remaining! > 0
                    ? 'You can create $remaining more wedding site${remaining == 1 ? '' : 's'} on the free plan.'
                    : 'You\'ve reached the free-plan limit. Upgrade to add more.',
            style: TextStyle(
              fontSize: 13,
              color: isPro
                  ? Colors.white.withValues(alpha: 0.9)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (usedPercent != null) ...[
            const SizedBox(height: AppTheme.space3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              child: LinearProgressIndicator(
                value: usedPercent,
                minHeight: 6,
                backgroundColor: AppColors.slate200,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
          const SizedBox(height: AppTheme.space4),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plan upgrades are coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    isPro ? Colors.white : Theme.of(context).colorScheme.primary,
                foregroundColor:
                    isPro ? AppColors.primary : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.space3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: Text(
                isPro ? 'Manage subscription' : 'Upgrade to Pro',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SECTION TITLE & SETTINGS LIST
// ═══════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final List<Widget> children;
  const _SettingsList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppTheme.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
