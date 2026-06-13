import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/wedding_repository.dart';
import '../../domain/wedding_model.dart';

class Step6Publish extends ConsumerStatefulWidget {
  final Map<String, dynamic> weddingData;

  const Step6Publish({
    super.key,
    required this.weddingData,
  });

  @override
  ConsumerState<Step6Publish> createState() => _Step6PublishState();
}

class _Step6PublishState extends ConsumerState<Step6Publish> {
  bool _isLoading = false;
  Wedding? _publishedWedding;

  Future<void> _publish() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(weddingRepositoryProvider);

      // Build a *copy* of the wedding data with API-friendly types, instead
      // of mutating the shared map (which would break step_2 if the user
      // navigates back).
      final payload = Map<String, dynamic>.from(widget.weddingData);

      // Normalize the date: API expects an ISO-8601 string. The shared map
      // may hold a DateTime (from step_2) or a String (revisited state).
      final rawDate = payload['weddingDate'];
      if (rawDate == null) {
        payload['weddingDate'] = DateTime.now().toIso8601String();
      } else if (rawDate is DateTime) {
        payload['weddingDate'] = rawDate.toIso8601String();
      }

      // Default to "Unnamed" if missing required fields for the API
      payload['groomName'] ??= "Groom";
      payload['brideName'] ??= "Bride";

      // Step 1: persist the wedding (server assigns slug + id)
      final created = await repo.createWedding(payload);

      // Step 2: explicitly publish (backend create() leaves isPublished=false)
      final published = await repo.publishWedding(created.id, true);

      if (mounted) {
        setState(() => _publishedWedding = published);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _copyLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  void _showQrCode(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openLiveSite(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the wedding website')),
        );
      }
    }
  }

  void _shareLink(BuildContext context, Wedding w, String url) {
    Share.share(
      'Check out ${w.groomName} & ${w.brideName}\'s wedding! $url',
      subject: '${w.groomName} & ${w.brideName} Wedding Invitation',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Once published, show the celebration panel; otherwise show the publish button.
    if (_publishedWedding != null) {
      final url = ApiConstants.publicWeddingUrl(_publishedWedding!.slug);
      return _PublishedCelebration(
        wedding: _publishedWedding!,
        url: url,
        onCopy: () => _copyLink(context, url),
        onQr: () => _showQrCode(context, url),
        onOpen: () => _openLiveSite(context, url),
        onShare: () => _shareLink(context, _publishedWedding!, url),
        onDone: () => context.go('/my-weddings'),
      );
    }

    return Column(
      children: [
        const Text('Review your details and publish.'),
        const SizedBox(height: 16),
        PrimaryButton(
          onPressed: _publish,
          label: 'Publish Wedding',
          isLoading: _isLoading,
        ),
      ],
    );
  }
}

class _PublishedCelebration extends StatelessWidget {
  final Wedding wedding;
  final String url;
  final VoidCallback onCopy;
  final VoidCallback onQr;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback onDone;

  const _PublishedCelebration({
    required this.wedding,
    required this.url,
    required this.onCopy,
    required this.onQr,
    required this.onOpen,
    required this.onShare,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Hero checkmark
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 72,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your wedding website is live!',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share this link with your guests so they can view your invitation.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // The URL
            Card(
              elevation: 0,
              color: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.amber.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        url,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy link',
                      onPressed: onCopy,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Primary actions
            ElevatedButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Live Site'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onQr,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('QR Code'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onDone,
              child: const Text('Done'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
