import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../wedding/presentation/wedding_controller.dart';
import 'package:wedding_cards/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);
    final weddingsState = ref.watch(weddingListControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weddingListControllerProvider);
          await Future<void>.delayed(const Duration(milliseconds: 500));
        },
        color: cs.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ─── Hero Header ───────────────────────────────────────
            SliverToBoxAdapter(
              child: _HeroHeader(
                userName: userState.valueOrNull?.displayName ?? 'Friend',
                localeCode: locale.languageCode,
                onLocaleToggle: () =>
                    ref.read(localeControllerProvider.notifier).toggleLocale(),
                isDark: isDark,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, curve: Curves.easeOutCubic),
            ),

            // ─── Content (responsive) ──────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.pagePadding(context),
                vertical: AppTheme.space6,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  // Stat Cards
                  weddingsState.when(
                    data: (weddings) {
                      final totalWeddings = weddings.length;
                      final totalViews = weddings.fold(0, (sum, w) => sum + w.viewCount);
                      final published = weddings.where((w) => w.isPublished).length;

                      return _StatGrid(
                        stats: [
                          _StatData(
                            title: l10n.totalSites,
                            value: '$totalWeddings',
                            icon: Icons.language_rounded,
                            color: AppColors.primary,
                            bgColor: AppColors.primarySurface,
                            bgColorDark: AppColors.primarySurfaceDark,
                          ),
                          _StatData(
                            title: l10n.totalViews,
                            value: '$totalViews',
                            icon: Icons.visibility_rounded,
                            color: AppColors.secondary,
                            bgColor: AppColors.secondarySurface,
                            bgColorDark: AppColors.secondarySurfaceDark,
                          ),
                          _StatData(
                            title: l10n.published,
                            value: '$published',
                            icon: Icons.public_rounded,
                            color: AppColors.tertiary,
                            bgColor: AppColors.tertiarySurface,
                            bgColorDark: AppColors.tertiarySurfaceDark,
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.05);
                    },
                    loading: () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.space8),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                    error: (e, _) => Text(
                      'Error loading stats: $e',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space8),

                  // Quick Actions header
                  Text(
                    l10n.quickActions,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppTheme.space4),

                  // Quick Action Cards
                  _ActionGrid(
                    actions: [
                      _ActionData(
                        title: l10n.createNew,
                        subtitle: 'Start a new wedding site',
                        icon: Icons.add_rounded,
                        gradient: AppColors.brandGradient,
                        onTap: () => context.go('/create'),
                      ),
                      _ActionData(
                        title: l10n.myWeddings,
                        subtitle: 'View all your weddings',
                        icon: Icons.favorite_rounded,
                        gradient: AppColors.warmGradient,
                        onTap: () => context.go('/my-weddings'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05),

                  const SizedBox(height: AppTheme.space8),

                  // Recent Weddings header
                  Text(
                    l10n.recentWeddings,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppTheme.space4),

                  // Recent Weddings
                  weddingsState.when(
                    data: (weddings) {
                      if (weddings.isEmpty) {
                        return _EmptyState(
                          icon: Icons.favorite_border_rounded,
                          title: l10n.noWeddingsCreated,
                          subtitle: 'Tap "Create new" to get started',
                        );
                      }
                      return Column(
                        children: weddings
                            .take(3)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppTheme.space3),
                                  child: _RecentWeddingTile(
                                    groomName: entry.value.groomName,
                                    brideName: entry.value.brideName,
                                    couplePhoto: entry.value.couplePhoto,
                                    viewCount: entry.value.viewCount,
                                    isPublished: entry.value.isPublished,
                                    onTap: () => context.go('/my-weddings'),
                                  ).animate().fadeIn(
                                        delay: (300 + entry.key * 80).ms,
                                        duration: 400.ms,
                                      ),
                                ))
                            .toList(),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppTheme.space12),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HERO HEADER
// ═══════════════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  final String userName;
  final String localeCode;
  final VoidCallback onLocaleToggle;
  final bool isDark;

  const _HeroHeader({
    required this.userName,
    required this.localeCode,
    required this.onLocaleToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return Container(
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
            AppTheme.space5,
            Responsive.pagePadding(context),
            AppTheme.space8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.space3),
              _PillButton(
                icon: Icons.translate_rounded,
                label: localeCode == 'en' ? 'മലയാളം' : 'English',
                onTap: onLocaleToggle,
              ),
              const SizedBox(width: AppTheme.space3),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STAT CARDS
// ═══════════════════════════════════════════════════════════════════
class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color bgColorDark;

  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.bgColorDark,
  });
}

class _StatGrid extends StatelessWidget {
  final List<_StatData> stats;
  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cols = Responsive.isCompact(context) ? 3 : Responsive.gridColumns(context);

    if (cols == stats.length) {
      return Row(
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            if (i > 0) const SizedBox(width: AppTheme.space3),
            Expanded(child: _StatCard(data: stats[i], isDark: isDark)),
          ],
        ],
      );
    }
    return Wrap(
      spacing: AppTheme.space3,
      runSpacing: AppTheme.space3,
      children: stats
          .map((s) => SizedBox(
                width: (MediaQuery.sizeOf(context).width -
                        Responsive.pagePadding(context) * 2 -
                        AppTheme.space3 * (cols - 1)) /
                    cols,
                child: _StatCard(data: s, isDark: isDark),
              ))
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  final bool isDark;
  const _StatCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.slate800 : AppColors.slate200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? data.bgColorDark : data.bgColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            data.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            data.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// ACTION CARDS
// ═══════════════════════════════════════════════════════════════════
class _ActionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class _ActionGrid extends StatelessWidget {
  final List<_ActionData> actions;
  const _ActionGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: AppTheme.space3),
          Expanded(child: _ActionCard(data: actions[i])),
        ],
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final _ActionData data;
  const _ActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        child: Ink(
          decoration: BoxDecoration(
            gradient: data.gradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: AppTheme.space5),
                Icon(data.icon, color: Colors.white, size: 32),
                const SizedBox(height: AppTheme.space3),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
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
// RECENT WEDDING TILE
// ═══════════════════════════════════════════════════════════════════
class _RecentWeddingTile extends StatelessWidget {
  final String groomName;
  final String brideName;
  final String? couplePhoto;
  final int viewCount;
  final bool isPublished;
  final VoidCallback onTap;

  const _RecentWeddingTile({
    required this.groomName,
    required this.brideName,
    required this.couplePhoto,
    required this.viewCount,
    required this.isPublished,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.space4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.slate800 : AppColors.slate200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                alignment: Alignment.center,
                child: couplePhoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        child: Image.network(
                          couplePhoto!,
                          fit: BoxFit.cover,
                          width: 52,
                          height: 52,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
              const SizedBox(width: AppTheme.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$groomName & $brideName',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$viewCount views',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppTheme.space3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPublished
                                ? AppColors.successSurface
                                : (isDark ? AppColors.slate800 : AppColors.slate100),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            isPublished ? 'Published' : 'Draft',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPublished
                                  ? AppColors.successDark
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space6,
        vertical: AppTheme.space10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.slate800
              : AppColors.slate200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
