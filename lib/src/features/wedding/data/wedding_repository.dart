import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_exception.dart';
import '../domain/wedding_model.dart';

part 'wedding_repository.g.dart';

class WeddingRepository {
  final Dio _dio;

  WeddingRepository(this._dio);

  Future<List<Wedding>> getWeddings() async {
    try {
      final response = await _dio.get(ApiConstants.weddingsBase);
      final data = response.data['data']['weddings'] as List;
      return data.map((json) => _parseWedding(json)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> getWeddingById(String id) async {
    try {
      final response = await _dio.get(ApiConstants.weddingById(id));
      final data = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> createWedding(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.weddingsBase, data: data);
      final dataMap = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(dataMap);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> updateWedding(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiConstants.weddingById(id), data: data);
      final dataMap = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(dataMap);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> publishWedding(String id, bool isPublished) async {
    try {
      final response = await _dio.patch(
        ApiConstants.weddingPublish(id),
        data: {'isPublished': isPublished},
      );
      final dataMap = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(dataMap);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> deleteWedding(String id) async {
    try {
      await _dio.delete(ApiConstants.weddingById(id));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<String>> uploadImages(List<String> filePaths) async {
    try {
      final formData = FormData.fromMap({
        'images': filePaths.map((filePath) {
          // Extract just the filename (everything after the last slash/separator)
          final filename = filePath.split(RegExp(r'[/\\]')).last;
          return MultipartFile.fromFileSync(filePath, filename: filename);
        }).toList(),
      });

      final response = await _dio.post(
        ApiConstants.uploadImage,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final urls = (response.data['data']['urls'] as List)
          .map((url) => url.toString())
          .toList();
      return urls;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> unpublishWedding(String id) async {
    try {
      final response = await _dio.patch(
        ApiConstants.weddingUnpublish(id),
        data: {'isPublished': false},
      );
      final dataMap = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(dataMap);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Wedding> duplicateWedding(String id) async {
    try {
      final response = await _dio.post(
        ApiConstants.weddingDuplicate(id),
        data: {},
      );
      final dataMap = response.data['data']['wedding'] as Map<String, dynamic>;
      return _parseWedding(dataMap);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> getStats(String id) async {
    try {
      final response = await _dio.get(ApiConstants.weddingStats(id));
      return Map<String, dynamic>.from(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Wedding _parseWedding(Map<String, dynamic> json) {
    // The backend returns `_id` and a virtual `id`.
    // The Wedding model expects `id` and has `serverId` mapped from `_id`.
    if (json['id'] == null && json['_id'] != null) {
      json = Map<String, dynamic>.from(json);
      json['id'] = json['_id'].toString();
    }
    return Wedding.fromJson(json);
  }

  ApiException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // Backend validation errors (422) come with a detailed error message
    if (statusCode == 422 && data is Map<String, dynamic>) {
      final message = data['message'] ?? 'Validation failed';
      return ApiException.validation(message: message);
    }

    // Handle specific error messages from the backend
    if (data is Map<String, dynamic>) {
      if (statusCode == 404 && data['message'] == 'Wedding not found') {
        return ApiException.notFound('Wedding not found');
      }
      if (statusCode == 403 && data['message'] == 'Not authorized') {
        return ApiException.forbidden(
          'You are not authorized to access this wedding',
        );
      }
    }

    // Use the standard error mapping from auth_repo
    if (statusCode != null) {
      switch (statusCode) {
        case 401:
          return ApiException.unauthorized();
        case 403:
          return ApiException.forbidden();
        case 404:
          return ApiException.notFound();
        case 429:
          return ApiException.rateLimited();
        case 500:
          return ApiException.serverError();
        case 422:
          return ApiException.validation();
        default:
          if (statusCode >= 500) {
            return ApiException.serverError();
          }
      }
    }

    // Network and timeouts
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException.timeout();
      case DioExceptionType.connectionError:
        return ApiException.network();
      case DioExceptionType.cancel:
        return ApiException.cancelled();
      default:
        return ApiException.unknown();
    }
  }
}

@riverpod
WeddingRepository weddingRepository(Ref ref) {
  return WeddingRepository(ref.watch(dioProvider));
}
