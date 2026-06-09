import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../domain/wedding_model.dart';

part 'wedding_repository.g.dart';

class WeddingRepository {
  final Dio _dio;

  WeddingRepository(this._dio);

  Future<List<Wedding>> getWeddings() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  Future<Wedding> getWeddingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Wedding(
      id: id,
      slug: 'mock-wedding-$id',
      groomName: 'Groom',
      brideName: 'Bride',
      weddingDate: DateTime.now().add(const Duration(days: 30)),
      isPublished: true,
      templateId: 'traditional-kerala',
    );
  }

  Future<Wedding> createWedding(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return Wedding(
      id: 'mock_wdg_123',
      slug: data['slug'] ?? 'mock-wedding',
      groomName: data['groomName'] ?? 'Groom',
      brideName: data['brideName'] ?? 'Bride',
      weddingDate: DateTime.now().add(const Duration(days: 30)),
      isPublished: false,
    );
  }

  Future<Wedding> updateWedding(String id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return Wedding(
      id: id,
      slug: data['slug'] ?? 'mock-wedding',
      groomName: data['groomName'] ?? 'Groom',
      brideName: data['brideName'] ?? 'Bride',
      weddingDate: DateTime.now().add(const Duration(days: 30)),
      isPublished: data['isPublished'] ?? false,
    );
  }

  Future<Wedding> publishWedding(String id, bool isPublished) async {
    await Future.delayed(const Duration(seconds: 1));
    return Wedding(
      id: id,
      slug: 'mock-wedding-$id',
      groomName: 'Groom',
      brideName: 'Bride',
      weddingDate: DateTime.now().add(const Duration(days: 30)),
      isPublished: isPublished,
    );
  }

  Future<void> deleteWedding(String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<List<String>> uploadImages(List<String> filePaths) async {
    await Future.delayed(const Duration(seconds: 2));
    return filePaths.map((p) => 'https://via.placeholder.com/800x600').toList();
  }
}

@riverpod
WeddingRepository weddingRepository(WeddingRepositoryRef ref) {
  return WeddingRepository(ref.watch(dioProvider));
}
