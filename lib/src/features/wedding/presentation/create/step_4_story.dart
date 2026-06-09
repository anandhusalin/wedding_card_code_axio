import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../../data/wedding_repository.dart';

class Step4Story extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step4Story({
    super.key,
    required this.initialData,
    required this.onSaved,
  });

  @override
  ConsumerState<Step4Story> createState() => _Step4StoryState();
}

class _Step4StoryState extends ConsumerState<Step4Story> {
  late TextEditingController _storyController;
  
  List<String> _galleryPhotosLocal = [];
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

    setState(() {
      _galleryPhotosLocal.addAll(paths);
      _isUploading = true;
    });

    try {
      final repo = ref.read(weddingRepositoryProvider);
      final urls = await repo.uploadImages(paths);
      
      final newPhotos = urls.map((url) => {'url': url, 'order': 0}).toList();
      
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _storyController,
          label: 'Our Story (Optional)',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 24),
        Text('Gallery Photos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_isUploading) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickAndUploadGallery,
          icon: const Icon(Icons.photo_library),
          label: const Text('Add Photos to Gallery'),
        ),
        const SizedBox(height: 16),
        
        // Display uploaded photos
        if (_galleryPhotosRemote.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _galleryPhotosRemote.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(_galleryPhotosRemote[index]['url']),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
