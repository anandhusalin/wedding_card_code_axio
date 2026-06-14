import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import 'rsvp_controller.dart';

class RsvpListScreen extends ConsumerWidget {
  final String weddingId;

  const RsvpListScreen({super.key, required this.weddingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(rsvpStatsControllerProvider(weddingId));
    final rsvpsState = ref.watch(rsvpListControllerProvider(weddingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVPs'),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          ref.invalidate(rsvpStatsControllerProvider(weddingId));
          ref.invalidate(rsvpListControllerProvider(weddingId));
          // Wait for both providers to settle so the spinner stops
          // at a sensible time.
          await Future<void>.delayed(const Duration(milliseconds: 300));
        },
        child: Column(
          children: [
            // Stats Header
            statsState.when(
              data: (stats) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.pagePadding(context),
                  vertical: AppTheme.space5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                // Wrap so 4 stat boxes reflow on narrow screens.
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: AppTheme.space4,
                  runSpacing: AppTheme.space3,
                  children: [
                    _StatBox(
                      label: 'Total',
                      value: stats.total.toString(),
                      color: AppColors.primary,
                    ),
                    _StatBox(
                      label: 'Attending',
                      value: stats.attending.toString(),
                      color: AppColors.success,
                    ),
                    _StatBox(
                      label: 'Declined',
                      value: stats.notAttending.toString(),
                      color: AppColors.error,
                    ),
                    _StatBox(
                      label: 'Maybe',
                      value: stats.maybe.toString(),
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.space4),
                color: AppColors.errorSurface,
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: AppTheme.space2),
                    Expanded(
                      child: Text(
                        'Couldn\'t load stats: $e',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .invalidate(rsvpStatsControllerProvider(weddingId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: rsvpsState.when(
                data: (rsvps) {
                  if (rsvps.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 80),
                        Center(
                          child: Text('No RSVPs received yet.'),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      Responsive.pagePadding(context),
                      AppTheme.space4,
                      Responsive.pagePadding(context),
                      AppTheme.space8,
                    ),
                    itemCount: rsvps.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final rsvp = rsvps[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(rsvp.status)
                              .withValues(alpha: 0.15),
                          child: Icon(
                            _getStatusIcon(rsvp.status),
                            color: _getStatusColor(rsvp.status),
                          ),
                        ),
                        title: Text(
                          rsvp.guestName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (rsvp.phone != null && rsvp.phone!.isNotEmpty)
                              Text('Phone: ${rsvp.phone}'),
                            if (rsvp.message != null && rsvp.message!.isNotEmpty)
                              Text(
                                'Message: "${rsvp.message}"',
                                style:
                                    const TextStyle(fontStyle: FontStyle.italic),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: rsvp.numberOfGuests > 1
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '+${rsvp.numberOfGuests - 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  );
                },
                loading: () => const LoadingListWidget(),
                error: (e, _) => AppErrorWidget(
                  message: e.toString(),
                  onRetry: () => ref
                      .invalidate(rsvpListControllerProvider(weddingId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'attending':
        return AppColors.success;
      case 'not_attending':
        return AppColors.error;
      case 'maybe':
        return AppColors.warning;
      default:
        return AppColors.slate500;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'attending':
        return Icons.check_circle;
      case 'not_attending':
        return Icons.cancel;
      case 'maybe':
        return Icons.help_outline;
      default:
        return Icons.info_outline;
    }
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    // Cap each stat box so 4 fit on compact (<600) screens without overflow.
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
