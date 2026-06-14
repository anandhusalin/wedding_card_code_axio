import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../../data/wedding_repository.dart';

class Step4Story extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step4Story({
    super.key,
    this.formKey,
    required this.initialData,
    required this.onSaved,
  });

  @override
  ConsumerState<Step4Story> createState() => _Step4StoryState();
}

class _Step4StoryState extends ConsumerState<Step4Story> {
  late TextEditingController _storyController;

  // Only the remote URLs (after upload) are displayed; the local paths are
  // a transient upload state and not kept around once `_save` fires.
  List<Map<String, dynamic>> _galleryPhotosRemote = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _storyController = TextEditingController(text: widget.initialData['coupleStory']);

    if (widget.initialData['galleryPhotos'] != null) {
      _galleryPhotosRemote = List<Map<String, dynamic>>.from(widget.initialData['galleryPhotos']);
    }
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSaved({
      'coupleStory': _storyController.text,
      'galleryPhotos': _galleryPhotosRemote,
    });
  }

  Future<void> _pickAndUploadGallery() async {
    final picker = ref.read(imagePickerProvider);
    final paths = await picker.pickMultipleImages();

    if (paths.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      final urls = await repo.uploadImages(paths);

      // Assign each photo an incremental order so the backend can sort them.
      final newPhotos = urls
          .asMap()
          .entries
          .map((e) => {'url': e.value, 'order': e.key + _galleryPhotosRemote.length})
          .toList();

      setState(() {
        _galleryPhotosRemote.addAll(newPhotos);
      });
      _save();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _galleryPhotosRemote.removeAt(index);
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Story ──────────────────────────────────────────
          _SectionHeader(
            icon: Icons.auto_awesome_rounded,
            title: 'Your story',
          ),
          const SizedBox(height: AppTheme.space4),
          AppTextField(
            controller: _storyController,
            label: 'Our Story (Optional)',
            hint: 'Share how you met, your first date, or what makes you special...',
            prefixIcon: Icons.favorite_rounded,
            maxLines: 5,
            validator: (v) => Validators.validateMessage(v, maxLength: 1000),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: AppTheme.space6),

          // ─── Gallery ───────────────────────────────────────
          _SectionHeader(
            icon: Icons.photo_library_rounded,
            title: 'Gallery Photos',
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your favorite moments together',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppTheme.space4),
          if (_isUploading)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.space4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                child: const LinearProgressIndicator(minHeight: 3),
              ),
            ),
          FilledButton.tonalIcon(
            onPressed: _isUploading ? null : _pickAndUploadGallery,
            icon: const Icon(Icons.add_photo_alternate_rounded),
            label: const Text('Add Photos to Gallery'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
            ),
          ),
          const SizedBox(height: AppTheme.space4),

          // Display uploaded photos
          if (_galleryPhotosRemote.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridColumns(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _galleryPhotosRemote.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Image.network(
                        _galleryPhotosRemote[index]['url'],
                        fit: BoxFit.cover,
                        // No width/height here — the grid cell sizes us.
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.slate100,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.slate400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: AppTheme.space3),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
