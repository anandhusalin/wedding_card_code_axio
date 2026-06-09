import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/wedding_model.dart';
import '../data/wedding_repository.dart';

part 'wedding_controller.g.dart';

@riverpod
class WeddingListController extends _$WeddingListController {
  @override
  FutureOr<List<Wedding>> build() async {
    return ref.watch(weddingRepositoryProvider).getWeddings();
  }

  Future<void> deleteWedding(String id) async {
    final previousState = state.valueOrNull;
    if (previousState == null) return;

    // Optimistic update
    state = AsyncData(previousState.where((w) => w.id != id).toList());

    try {
      await ref.read(weddingRepositoryProvider).deleteWedding(id);
    } catch (e, st) {
      state = AsyncError(e, st);
      // Revert on error
      ref.invalidateSelf();
    }
  }

  Future<void> publishWedding(String id, bool isPublished) async {
    state = const AsyncLoading();
    try {
      await ref.read(weddingRepositoryProvider).publishWedding(id, isPublished);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
