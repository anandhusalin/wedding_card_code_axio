import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
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
      body: Column(
        children: [
          // Stats Header
          statsState.when(
            data: (stats) => Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBox('Total', stats.total.toString(), Colors.blue),
                  _StatBox('Attending', stats.attending.toString(), Colors.green),
                  _StatBox('Declined', stats.notAttending.toString(), Colors.red),
                  _StatBox('Maybe', stats.maybe.toString(), Colors.orange),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // List
          Expanded(
            child: rsvpsState.when(
              data: (rsvps) {
                if (rsvps.isEmpty) {
                  return const Center(
                    child: Text('No RSVPs received yet.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rsvps.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final rsvp = rsvps[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(rsvp.status).withOpacity(0.2),
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
                            Text('Message: "${rsvp.message}"',
                                style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '+${rsvp.numberOfGuests}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingListWidget(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(rsvpListControllerProvider(weddingId)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'attending':
        return Colors.green;
      case 'not_attending':
        return Colors.red;
      case 'maybe':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'attending':
        return Icons.check_circle;
      case 'not_attending':
        return Icons.cancel;
      case 'maybe':
        return Icons.help;
      default:
        return Icons.info;
    }
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
