import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../../data/wedding_repository.dart';

class Step1CoupleInfo extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step1CoupleInfo({
    super.key,
    required this.initialData,
    required this.onSaved,
  });

  @override
  ConsumerState<Step1CoupleInfo> createState() => _Step1CoupleInfoState();
}

class _Step1CoupleInfoState extends ConsumerState<Step1CoupleInfo> {
  late TextEditingController _groomController;
  late TextEditingController _brideController;

  String? _groomPhotoPath; // local path
  String? _groomPhotoUrl;  // uploaded URL
  
  String? _bridePhotoPath;
  String? _bridePhotoUrl;
  
  String? _couplePhotoPath;
  String? _couplePhotoUrl;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _groomController = TextEditingController(text: widget.initialData['groomName']);
    _brideController = TextEditingController(text: widget.initialData['brideName']);
    
    _groomPhotoUrl = widget.initialData['groomPhoto'];
    _bridePhotoUrl = widget.initialData['bridePhoto'];
    _couplePhotoUrl = widget.initialData['couplePhoto'];
  }

  @override
  void dispose() {
    _groomController.dispose();
    _brideController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSaved({
      'groomName': _groomController.text,
      'brideName': _brideController.text,
      if (_groomPhotoUrl != null) 'groomPhoto': _groomPhotoUrl,
      if (_bridePhotoUrl != null) 'bridePhoto': _bridePhotoUrl,
      if (_couplePhotoUrl != null) 'couplePhoto': _couplePhotoUrl,
    });
  }

  Future<void> _pickAndUploadImage(String type) async {
    final picker = ref.read(imagePickerProvider);
    final path = await picker.pickImage();
    
    if (path == null) return;

    setState(() {
      if (type == 'groom') _groomPhotoPath = path;
      if (type == 'bride') _bridePhotoPath = path;
      if (type == 'couple') _couplePhotoPath = path;
      _isUploading = true;
    });

    try {
      final repo = ref.read(weddingRepositoryProvider);
      final urls = await repo.uploadImages([path]);
      
      if (urls.isNotEmpty) {
        setState(() {
          if (type == 'groom') _groomPhotoUrl = urls.first;
          if (type == 'bride') _bridePhotoUrl = urls.first;
          if (type == 'couple') _couplePhotoUrl = urls.first;
        });
        _save();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Widget _buildPhotoPicker(String label, String type, String? localPath, String? remoteUrl) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isUploading ? null : () => _pickAndUploadImage(type),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(60),
              image: localPath != null
                  ? DecorationImage(image: FileImage(File(localPath)), fit: BoxFit.cover)
                  : remoteUrl != null
                      ? DecorationImage(image: NetworkImage(remoteUrl), fit: BoxFit.cover)
                      : null,
            ),
            child: localPath == null && remoteUrl == null
                ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isUploading) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPhotoPicker('Groom Photo', 'groom', _groomPhotoPath, _groomPhotoUrl),
            _buildPhotoPicker('Bride Photo', 'bride', _bridePhotoPath, _bridePhotoUrl),
          ],
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: _groomController,
          label: 'Groom Name',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _brideController,
          label: 'Bride Name',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 24),
        _buildPhotoPicker('Main Couple Cover Photo (Landscape)', 'couple', _couplePhotoPath, _couplePhotoUrl),
      ],
    );
  }
}
