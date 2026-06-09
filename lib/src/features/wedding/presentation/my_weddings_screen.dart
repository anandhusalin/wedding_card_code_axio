import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/pdf_generator_service.dart';
import '../../../core/theme/app_colors.dart';
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
      ),
      body: weddingsState.when(
        data: (weddings) {
          if (weddings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No weddings created yet.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/create'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Wedding'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(weddingListControllerProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: weddings.length,
              itemBuilder: (context, index) {
                return WeddingCardWidget(wedding: weddings[index]);
              },
            ),
          );
        },
        loading: () => const LoadingListWidget(itemHeight: 120),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(weddingListControllerProvider),
        ),
      ),
    );
  }
}

class WeddingCardWidget extends ConsumerWidget {
  final Wedding wedding;

  const WeddingCardWidget({super.key, required this.wedding});

  Future<void> _openPreview(BuildContext context) async {
    final url = Uri.parse('${ApiConstants.defaultBaseUrl}/${wedding.slug}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch preview')),
        );
      }
    }
  }

  void _shareWedding(BuildContext context) {
    final url = '${ApiConstants.defaultBaseUrl}/${wedding.slug}';
    Share.share('Check out our wedding website! $url');
  }

  void _showQrCode(BuildContext context) {
    final url = '${ApiConstants.defaultBaseUrl}/${wedding.slug}';
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
                image: AssetImage('assets/images/app_logo.png'), // placeholder
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _shareWedding(context);
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Go to details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wedding.couplePhoto != null)
              Image.network(
                wedding.couplePhoto!,
                height: 140,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.favorite, color: Colors.white, size: 48),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${wedding.groomName} & ${wedding.brideName}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair Display',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: wedding.isPublished ? Colors.green[100] : Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          wedding.isPublished ? 'Published' : 'Draft',
                          style: TextStyle(
                            fontSize: 12,
                            color: wedding.isPublished ? Colors.green[800] : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        wedding.weddingDate.toIso8601String().split('T')[0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${wedding.viewCount} views',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => _openPreview(context),
                        icon: const Icon(Icons.public),
                        label: const Text('Preview'),
                      ),
                      if (wedding.isRsvpEnabled)
                        TextButton.icon(
                          onPressed: () => context.go('/my-weddings/${wedding.id}/rsvps'),
                          icon: const Icon(Icons.people),
                          label: const Text('RSVPs'),
                        ),
                      TextButton.icon(
                        onPressed: () => _showQrCode(context),
                        icon: const Icon(Icons.qr_code),
                        label: const Text('QR Code'),
                      ),
                      TextButton.icon(
                        onPressed: () => _shareWedding(context),
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                      TextButton.icon(
                        onPressed: () => PdfGeneratorService.generateAndPrintWeddingInvitation(wedding),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
