import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../../../../core/utils/validators.dart';
import '../../data/wedding_repository.dart';

class Step1CoupleInfo extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step1CoupleInfo({
    super.key,
    this.formKey,
    required this.initialData,
    required this.onSaved,
  });

  @override
  ConsumerState<Step1CoupleInfo> createState() => _Step1CoupleInfoState();
}

class _Step1CoupleInfoState extends ConsumerState<Step1CoupleInfo> {
  late TextEditingController _groomController;
  late TextEditingController _brideController;

  String? _groomPhotoPath;
  String? _groomPhotoUrl;
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

  Widget _buildPhotoPicker(
    String label,
    String type,
    String? localPath,
    String? remoteUrl, {
    double size = 110,
    bool isLandscape = false,
  }) {
    final hasImage = localPath != null || remoteUrl != null;
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppTheme.space3),
        GestureDetector(
          onTap: _isUploading ? null : () => _pickAndUploadImage(type),
          child: Container(
            height: isLandscape ? 140 : size,
            width: isLandscape ? double.infinity : size,
            decoration: BoxDecoration(
              color: isLandscape
                  ? AppColors.primarySurface
                  : cs.surface,
              borderRadius: BorderRadius.circular(
                isLandscape ? AppTheme.radiusXl : size,
              ),
              border: Border.all(
                color: hasImage
                    ? Colors.transparent
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.slate700
                        : AppColors.slate300),
                width: 1.5,
                style: hasImage ? BorderStyle.none : BorderStyle.solid,
              ),
              image: hasImage
                  ? DecorationImage(
                      image: localPath != null
                          ? FileImage(File(localPath))
                          : NetworkImage(remoteUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: hasImage
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.space2),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLandscape
                              ? Icons.add_photo_alternate_rounded
                              : Icons.add_a_photo_rounded,
                          size: isLandscape ? 28 : 28,
                          color: AppColors.primary,
                        ),
                        if (isLandscape) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Tap to upload',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isUploading)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.space4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                child: const LinearProgressIndicator(minHeight: 3),
              ),
            ),
          // ─── Photo row ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoPicker('Groom', 'groom', _groomPhotoPath, _groomPhotoUrl),
              _buildPhotoPicker('Bride', 'bride', _bridePhotoPath, _bridePhotoUrl),
            ],
          ),
          const SizedBox(height: AppTheme.space8),

          // ─── Name fields ───────────────────────────────────
          AppTextField(
            controller: _groomController,
            label: 'Groom name',
            hint: 'e.g. John',
            prefixIcon: Icons.person_outline_rounded,
            validator: (v) => Validators.validateName(v),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: AppTheme.space4),
          AppTextField(
            controller: _brideController,
            label: 'Bride name',
            hint: 'e.g. Jane',
            prefixIcon: Icons.person_outline_rounded,
            validator: (v) => Validators.validateName(v),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: AppTheme.space8),

          // ─── Cover photo ───────────────────────────────────
          _buildPhotoPicker(
            'Main cover photo',
            'couple',
            _couplePhotoPath,
            _couplePhotoUrl,
            isLandscape: true,
          ),
        ],
      ),
    );
  }
}
