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

    // Optimistic update: remove the item immediately
    state = AsyncData(previousState.where((w) => w.id != id).toList());

    try {
      await ref.read(weddingRepositoryProvider).deleteWedding(id);
    } catch (e) {
      // Revert: restore the original list and re-throw so the caller
      // (UI) can show a snackbar. We do NOT swap state to AsyncError,
      // because that would blank the whole list for one failed delete.
      state = AsyncData(previousState);
      rethrow;
    }
  }

  Future<void> publishWedding(String id, bool isPublished) async {
    final previousState = state.valueOrNull;
    if (previousState == null) return;

    // Optimistic update: flip the published flag for the specific wedding
    // without reloading the entire list.
    state = AsyncData(previousState.map((w) {
      return w.id == id ? _withPublished(w, isPublished) : w;
    }).toList());

    try {
      await ref.read(weddingRepositoryProvider).publishWedding(id, isPublished);
    } catch (e) {
      // Revert just this wedding's published flag.
      state = AsyncData(state.valueOrNull!.map((w) {
        return w.id == id ? _withPublished(w, !isPublished) : w;
      }).toList());
      // Re-throw so the caller (UI) can show a snackbar.
      rethrow;
    }
  }

  /// Freezed-friendly copy: re-emit a Wedding with `isPublished` flipped.
  /// `copyWith` requires named fields exposed by the freezed class.
  Wedding _withPublished(Wedding w, bool isPublished) {
    return w.copyWith(isPublished: isPublished);
  }

  /// Convenience: pull-to-refresh. Returns when the network call completes.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
