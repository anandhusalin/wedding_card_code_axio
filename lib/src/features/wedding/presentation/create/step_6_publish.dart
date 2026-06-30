import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
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

  /// Check that the minimum required fields are populated. If not, returns
  /// a user-friendly error message; otherwise null.
  String? _validateRequired() {
    final data = widget.weddingData;
    if ((data['groomName'] as String?)?.trim().isNotEmpty != true) {
      return 'Please enter the groom\'s name in Step 1.';
    }
    if ((data['brideName'] as String?)?.trim().isNotEmpty != true) {
      return 'Please enter the bride\'s name in Step 1.';
    }
    if (data['weddingDate'] == null) {
      return 'Please pick a wedding date in Step 2.';
    }
    final venue = data['venue'];
    if (venue is Map &&
        (venue['name'] as String?)?.trim().isNotEmpty != true) {
      return 'Please add a venue name in Step 2.';
    }
    return null;
  }

  Future<void> _publish() async {
    final validationError = _validateRequired();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(weddingRepositoryProvider);

      final payload = Map<String, dynamic>.from(widget.weddingData);

      final rawDate = payload['weddingDate'];
      if (rawDate is DateTime) {
        payload['weddingDate'] = rawDate.toIso8601String();
      } else if (rawDate is String) {
        // already serialized, leave as-is
      }

      final created = await repo.createWedding(payload);
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
    if (_publishedWedding != null) {
      final config = ref.read(appConfigProvider);
      final url = '${config.publicBaseUrl}/${_publishedWedding!.slug}';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.space6),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to go live',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review your details and publish. You can edit anytime afterwards.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.space6),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppTheme.space6),
            // Hero checkmark
            Center(
              child: Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  gradient: AppColors.successGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.4),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space6),
            Text(
              'Your wedding website is live!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              'Share this link with your guests so they can view your invitation.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.space6),

            // The URL
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space4,
                vertical: AppTheme.space2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      url,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: 'Copy link',
                    onPressed: onCopy,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space4),

            // Primary actions
            FilledButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_new_rounded, size: 20),
              label: const Text('View Live Site'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
              ),
            ),
            const SizedBox(height: AppTheme.space3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onQr,
                    icon: const Icon(Icons.qr_code_rounded, size: 18),
                    label: const Text('QR Code'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.space3),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space4),
            TextButton(
              onPressed: onDone,
              child: const Text('Done'),
            ),
            const SizedBox(height: AppTheme.space4),
          ],
        ),
      ),
    );
  }
}
