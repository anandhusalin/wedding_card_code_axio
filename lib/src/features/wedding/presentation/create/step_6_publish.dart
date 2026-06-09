import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/wedding_repository.dart';

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

  Future<void> _publish() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(weddingRepositoryProvider);
      
      // Ensure we have a date, API expects it
      if (widget.weddingData['weddingDate'] == null) {
        widget.weddingData['weddingDate'] = DateTime.now().toIso8601String();
      } else if (widget.weddingData['weddingDate'] is DateTime) {
        widget.weddingData['weddingDate'] = (widget.weddingData['weddingDate'] as DateTime).toIso8601String();
      }
      
      // Default to "Unnamed" if missing required fields for the API
      widget.weddingData['groomName'] ??= "Groom";
      widget.weddingData['brideName'] ??= "Bride";

      final created = await repo.createWedding(widget.weddingData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wedding created successfully!')),
        );
        // Optionally pop or go to preview
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
