import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/pdf_generator_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../domain/wedding_model.dart';
import 'wedding_controller.dart';

class MyWeddingsScreen extends ConsumerWidget {
  const MyWeddingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weddingsState = ref.watch(weddingListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Weddings'),
        actions: [
          IconButton(
            onPressed: () => context.go('/create'),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.space3),
        ],
      ),
      body: weddingsState.when(
        data: (weddings) {
          if (weddings.isEmpty) {
            return _EmptyWeddingsState(
              onCreate: () => context.go('/create'),
            );
          }

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              ref.invalidate(weddingListControllerProvider);
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = Responsive.gridColumns(context);
                if (cols == 1) {
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      Responsive.pagePadding(context),
                      AppTheme.space4,
                      Responsive.pagePadding(context),
                      AppTheme.space8,
                    ),
                    itemCount: weddings.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppTheme.space3),
                    itemBuilder: (context, index) =>
                        WeddingCardWidget(wedding: weddings[index]),
                  );
                }
                final width = constraints.maxWidth;
                final gap = AppTheme.space3;
                final cardWidth = (width - gap * (cols - 1)) / cols;
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    AppTheme.space4,
                    Responsive.pagePadding(context),
                    AppTheme.space8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: gap,
                    mainAxisSpacing: gap,
                    childAspectRatio: 0.78,
                    mainAxisExtent: cardWidth * 1.3,
                  ),
                  itemCount: weddings.length,
                  itemBuilder: (context, index) =>
                      WeddingCardWidget(wedding: weddings[index]),
                );
              },
            ),
          );
        },
        loading: () => const LoadingListWidget(itemHeight: 140),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(weddingListControllerProvider),
        ),
      ),
    );
  }
}

class _EmptyWeddingsState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyWeddingsState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: AppTheme.space6),
            Text(
              'No weddings yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              'Create your first beautiful wedding site and start collecting RSVPs.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.space6),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Create New Wedding'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space6,
                  vertical: AppTheme.space4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeddingCardWidget extends ConsumerWidget {
  final Wedding wedding;

  const WeddingCardWidget({super.key, required this.wedding});

  Future<void> _openPreview(BuildContext context) async {
    final url = Uri.parse(ApiConstants.publicWeddingUrl(wedding.slug));
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch preview')),
        );
      }
    }
  }

  void _shareWedding(BuildContext context) {
    final url = ApiConstants.publicWeddingUrl(wedding.slug);
    Share.share('Check out our wedding website! $url');
  }

  void _showQrCode(BuildContext context) {
    final url = ApiConstants.publicWeddingUrl(wedding.slug);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wedding QR Code', textAlign: TextAlign.center),
        content: SizedBox(
          width: 250,
          height: 250,
          child: PrettyQrView.data(
            data: url,
            decoration: const PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage('assets/images/app_logo.png'),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _shareWedding(context);
            },
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            border: Border.all(
              color: isDark ? AppColors.slate800 : AppColors.slate200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Cover ──────────────────────────────────────────
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (wedding.couplePhoto != null)
                      Image.network(
                        wedding.couplePhoto!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _CoverFallback(),
                      )
                    else
                      _CoverFallback(),
                    // Gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Status pill
                    Positioned(
                      top: AppTheme.space3,
                      right: AppTheme.space3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: wedding.isPublished
                              ? AppColors.success
                              : AppColors.tertiary,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              wedding.isPublished
                                  ? Icons.check_circle_rounded
                                  : Icons.edit_note_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              wedding.isPublished ? 'Published' : 'Draft',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Body ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppTheme.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${wedding.groomName} & ${wedding.brideName}',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.space2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          wedding.weddingDate.toIso8601String().split('T')[0],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppTheme.space3),
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${wedding.viewCount}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space4),
                    // ─── Action row ─────────────────────────────────
                    Row(
                      children: [
                        _MiniIconButton(
                          icon: Icons.public_rounded,
                          tooltip: 'Preview',
                          onTap: () => _openPreview(context),
                        ),
                        if (wedding.isRsvpEnabled)
                          _MiniIconButton(
                            icon: Icons.people_alt_rounded,
                            tooltip: 'RSVPs',
                            onTap: () => context.go(
                                '/my-weddings/${wedding.id}/rsvps'),
                          ),
                        _MiniIconButton(
                          icon: Icons.qr_code_rounded,
                          tooltip: 'QR Code',
                          onTap: () => _showQrCode(context),
                        ),
                        _MiniIconButton(
                          icon: Icons.share_rounded,
                          tooltip: 'Share',
                          onTap: () => _shareWedding(context),
                        ),
                        const Spacer(),
                        _MiniIconButton(
                          icon: Icons.picture_as_pdf_rounded,
                          tooltip: 'PDF',
                          color: AppColors.secondary,
                          onTap: () => PdfGeneratorService
                              .generateAndPrintWeddingInvitation(wedding),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.brandGradient),
      child: const Center(
        child: Icon(Icons.favorite_rounded, color: Colors.white, size: 48),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  const _MiniIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.slate800 : AppColors.slate100,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(icon, size: 16, color: c),
        ),
      ),
    );
  }
}
