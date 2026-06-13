import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_cards/src/core/constants/api_constants.dart';
import 'package:wedding_cards/src/core/network/api_exception.dart';
import 'package:wedding_cards/src/features/wedding/data/wedding_repository.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late WeddingRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = WeddingRepository(dio);
  });

  group('getWeddings', () {
    test('returns list of weddings', () async {
      final weddingsJson = [
        {
          '_id': 'w-1',
          'slug': 'wedding-1',
          'groomName': 'John',
          'brideName': 'Jane',
        },
        {
          '_id': 'w-2',
          'slug': 'wedding-2',
          'groomName': 'Mike',
          'brideName': 'Sarah',
        }
      ];

      when(() => dio.get(ApiConstants.weddingsBase)).thenAnswer((_) async => Response(
        data: {'data': {'weddings': weddingsJson}},
        requestOptions: RequestOptions(path: ApiConstants.weddingsBase),
      ));

      final weddings = await repo.getWeddings();

      expect(weddings, hasLength(2));
      expect(weddings[0].id, 'w-1');
      expect(weddings[1].brideName, 'Sarah');
    });

    test('maps _id to id', () async {
      final weddingJson = {
        '_id': 'backend-id-123',
        'slug': 'test-wedding',
        'groomName': 'Test',
        'brideName': 'Couple',
      };

      when(() => dio.get(ApiConstants.weddingsBase)).thenAnswer((_) async => Response(
        data: {'data': {'weddings': [weddingJson]}},
        requestOptions: RequestOptions(path: ApiConstants.weddingsBase),
      ));

      final weddings = await repo.getWeddings();
      expect(weddings[0].id, 'backend-id-123');
    });

    test('throws on API error', () async {
      when(() => dio.get(ApiConstants.weddingsBase)).thenThrow(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ApiConstants.weddingsBase),
      ));

      expect(() => repo.getWeddings(), throwsA(isA<ApiException>()));
    });
  });

  group('getWeddingById', () {
    test('returns single wedding', () async {
      const weddingId = 'w-456';
      final weddingJson = {
        '_id': weddingId,
        'slug': 'john-and-jane',
        'groomName': 'John',
        'brideName': 'Jane',
        'weddingDate': '2027-06-15T10:00:00.000Z',
      };

      when(() => dio.get(ApiConstants.weddingById(weddingId))).thenAnswer((_) async => Response(
        data: {'data': {'wedding': weddingJson}},
        requestOptions: RequestOptions(path: ApiConstants.weddingById(weddingId)),
      ));

      final wedding = await repo.getWeddingById(weddingId);

      expect(wedding.id, weddingId);
      expect(wedding.groomName, 'John');
      expect(wedding.weddingDate, isA<DateTime>());
    });
  });

  group('createWedding', () {
    test('sends payload and returns wedding', () async {
      const payload = {
        'groomName': 'Tom',
        'brideName': 'Lisa',
        'weddingDate': '2027-07-20T10:00:00.000Z',
      };

      final weddingJson = {
        '_id': 'new-789',
        'slug': 'tom-and-lisa-2027',
        ...payload,
      };

      when(() => dio.post(
        ApiConstants.weddingsBase,
        data: payload,
      )).thenAnswer((_) async => Response(
        data: {'data': {'wedding': weddingJson}},
        requestOptions: RequestOptions(path: ApiConstants.weddingsBase),
      ));

      final wedding = await repo.createWedding(payload);

      expect(wedding.id, 'new-789');
      expect(wedding.groomName, 'Tom');
    });
  });

  group('updateWedding', () {
    test('sends PUT with id in path', () async {
      const payload = {'additionalNotes': 'New notes'};
      const weddingId = 'w-123';
      final expectedUrl = ApiConstants.weddingById(weddingId);

      when(() => dio.put(
        expectedUrl,
        data: payload,
      )).thenAnswer((_) async => Response(
        data: {'data': {'wedding': {'_id': weddingId, 'groomName': 'Updated'}}},
        requestOptions: RequestOptions(path: expectedUrl),
      ));

      final wedding = await repo.updateWedding(weddingId, payload);
      expect(wedding.groomName, 'Updated');
    });
  });

  group('publishWedding', () {
    test('sends PATCH with isPublished=true', () async {
      const weddingId = 'w-123';
      final expectedUrl = ApiConstants.weddingPublish(weddingId);
      final weddingJson = {
        '_id': weddingId,
        'isPublished': true,
      };

      when(() => dio.patch(
        expectedUrl,
        data: {'isPublished': true},
      )).thenAnswer((_) async => Response(
        data: {'data': {'wedding': weddingJson}},
        requestOptions: RequestOptions(path: expectedUrl),
      ));

      final wedding = await repo.publishWedding(weddingId, true);
      expect(wedding.isPublished, true);
    });
  });

  group('deleteWedding', () {
    test('sends DELETE request', () async {
      const weddingId = 'w-123';
      final expectedUrl = ApiConstants.weddingById(weddingId);

      when(() => dio.delete(expectedUrl)).thenAnswer((_) async => Response(
        data: {},
        requestOptions: RequestOptions(path: expectedUrl),
      ));

      await expectLater(() => repo.deleteWedding(weddingId), completes);
      verify(() => dio.delete(expectedUrl)).called(1);
    });
  });

  group('duplicateWedding', () {
    test('sends POST with /duplicate', () async {
      const weddingId = 'w-123';
      final expectedUrl = ApiConstants.weddingDuplicate(weddingId);

      when(() => dio.post(expectedUrl)).thenAnswer((_) async => Response(
        data: {
          'data': {
            'wedding': {
              '_id': 'new-wedding',
              'slug': 'copy-of-original',
            }
          }
        },
        requestOptions: RequestOptions(path: expectedUrl),
      ));

      final wedding = await repo.duplicateWedding(weddingId);
      expect(wedding.id, 'new-wedding');
    });
  });

  group('getStats', () {
    test('returns wedding stats map', () async {
      const weddingId = 'w-123';
      final expectedUrl = ApiConstants.weddingStats(weddingId);

      when(() => dio.get(expectedUrl)).thenAnswer((_) async => Response(
        data: {'data': {'views': 42, 'rsvps': 15}},
        requestOptions: RequestOptions(path: expectedUrl),
      ));

      final stats = await repo.getStats(weddingId);
      expect(stats, {'views': 42, 'rsvps': 15});
    });
  });
}