import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../domain/rsvp_model.dart';

part 'rsvp_repository.g.dart';

class RsvpRepository {
  // ignore: unused_field
  final Dio _dio;

  RsvpRepository(this._dio);

  Future<List<Rsvp>> getRsvps(String weddingId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rsvp(
        id: 'rsvp_1',
        weddingId: weddingId,
        guestName: 'John Doe',
        status: 'attending',
        numberOfGuests: 2,
        message: 'Looking forward to it!',
      ),
      Rsvp(
        id: 'rsvp_2',
        weddingId: weddingId,
        guestName: 'Jane Smith',
        status: 'not_attending',
        numberOfGuests: 1,
      ),
    ];
  }

  Future<RsvpStats> getRsvpStats(String weddingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RsvpStats(
      total: 2,
      attending: 1,
      notAttending: 1,
      maybe: 0,
    );
  }
}

@riverpod
RsvpRepository rsvpRepository(Ref ref) {
  return RsvpRepository(ref.watch(dioProvider));
}
