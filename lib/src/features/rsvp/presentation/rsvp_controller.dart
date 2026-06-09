import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/rsvp_model.dart';
import '../data/rsvp_repository.dart';

part 'rsvp_controller.g.dart';

@riverpod
class RsvpListController extends _$RsvpListController {
  @override
  FutureOr<List<Rsvp>> build(String weddingId) async {
    return ref.watch(rsvpRepositoryProvider).getRsvps(weddingId);
  }
}

@riverpod
class RsvpStatsController extends _$RsvpStatsController {
  @override
  FutureOr<RsvpStats> build(String weddingId) async {
    return ref.watch(rsvpRepositoryProvider).getRsvpStats(weddingId);
  }
}
