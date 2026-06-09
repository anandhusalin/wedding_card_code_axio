import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress to save bandwidth
        maxWidth: 1200,
      );
      return image?.path;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
      );
      return images.map((e) => e.path).toList();
    } catch (e) {
      return [];
    }
  }
}

final imagePickerProvider = Provider((ref) => ImagePickerService());
