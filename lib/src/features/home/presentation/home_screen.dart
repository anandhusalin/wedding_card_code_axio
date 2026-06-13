import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../wedding/presentation/wedding_controller.dart';
import '../../../core/providers/locale_provider.dart';
import 'package:wedding_cards/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);
    final weddingsState = ref.watch(weddingListControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(weddingListControllerProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Welcome Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.welcomeBack,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              userState.valueOrNull?.displayName ?? 'Admin',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => ref.read(localeControllerProvider.notifier).toggleLocale(),
                              icon: const Icon(Icons.language),
                              label: Text(locale.languageCode == 'en' ? 'മലയാളം' : 'English'),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              child: const Icon(Icons.person, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Quick Stats
                    weddingsState.when(
                      data: (weddings) {
                        final totalWeddings = weddings.length;
                        final totalViews = weddings.fold(0, (sum, w) => sum + w.viewCount);
                        final published = weddings.where((w) => w.isPublished).length;

                        return Row(
                          children: [
                            Expanded(child: _StatCard(title: l10n.totalSites, value: '$totalWeddings', icon: Icons.web)),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCard(title: l10n.totalViews, value: '$totalViews', icon: Icons.visibility)),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCard(title: l10n.published, value: '$published', icon: Icons.public)),
                          ],
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error loading stats: $e'),
                    ),
                    const SizedBox(height: 32),

                    // Quick Actions
                    Text(
                      l10n.quickActions,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            title: l10n.createNew,
                            icon: Icons.add_circle,
                            color: Colors.green,
                            onTap: () => context.go('/create'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ActionCard(
                            title: l10n.myWeddings,
                            icon: Icons.favorite,
                            color: Colors.pink,
                            onTap: () => context.go('/my-weddings'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Recent Activity
                    Text(
                      l10n.recentWeddings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    weddingsState.when(
                      data: (weddings) {
                        if (weddings.isEmpty) {
                          return Center(child: Text(l10n.noWeddingsCreated));
                        }
                        return Column(
                          children: weddings.take(3).map((w) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: w.couplePhoto != null ? NetworkImage(w.couplePhoto!) : null,
                              child: w.couplePhoto == null ? const Icon(Icons.favorite) : null,
                            ),
                            title: Text('${w.groomName} & ${w.brideName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Views: ${w.viewCount}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => context.go('/my-weddings'),
                          )).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
