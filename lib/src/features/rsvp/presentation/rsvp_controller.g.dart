// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rsvpListControllerHash() =>
    r'ce68da6054978cdb696288448353d083d6d0f27d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RsvpListController
    extends BuildlessAutoDisposeAsyncNotifier<List<Rsvp>> {
  late final String weddingId;

  FutureOr<List<Rsvp>> build(String weddingId);
}

/// See also [RsvpListController].
@ProviderFor(RsvpListController)
const rsvpListControllerProvider = RsvpListControllerFamily();

/// See also [RsvpListController].
class RsvpListControllerFamily extends Family<AsyncValue<List<Rsvp>>> {
  /// See also [RsvpListController].
  const RsvpListControllerFamily();

  /// See also [RsvpListController].
  RsvpListControllerProvider call(String weddingId) {
    return RsvpListControllerProvider(weddingId);
  }

  @override
  RsvpListControllerProvider getProviderOverride(
    covariant RsvpListControllerProvider provider,
  ) {
    return call(provider.weddingId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rsvpListControllerProvider';
}

/// See also [RsvpListController].
class RsvpListControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<RsvpListController, List<Rsvp>> {
  /// See also [RsvpListController].
  RsvpListControllerProvider(String weddingId)
    : this._internal(
        () => RsvpListController()..weddingId = weddingId,
        from: rsvpListControllerProvider,
        name: r'rsvpListControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$rsvpListControllerHash,
        dependencies: RsvpListControllerFamily._dependencies,
        allTransitiveDependencies:
            RsvpListControllerFamily._allTransitiveDependencies,
        weddingId: weddingId,
      );

  RsvpListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weddingId,
  }) : super.internal();

  final String weddingId;

  @override
  FutureOr<List<Rsvp>> runNotifierBuild(covariant RsvpListController notifier) {
    return notifier.build(weddingId);
  }

  @override
  Override overrideWith(RsvpListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RsvpListControllerProvider._internal(
        () => create()..weddingId = weddingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weddingId: weddingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RsvpListController, List<Rsvp>>
  createElement() {
    return _RsvpListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RsvpListControllerProvider && other.weddingId == weddingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weddingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RsvpListControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Rsvp>> {
  /// The parameter `weddingId` of this provider.
  String get weddingId;
}

class _RsvpListControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<RsvpListController, List<Rsvp>>
    with RsvpListControllerRef {
  _RsvpListControllerProviderElement(super.provider);

  @override
  String get weddingId => (origin as RsvpListControllerProvider).weddingId;
}

String _$rsvpStatsControllerHash() =>
    r'c6f2e470622e7a5d470105c43518578e9298520b';

abstract class _$RsvpStatsController
    extends BuildlessAutoDisposeAsyncNotifier<RsvpStats> {
  late final String weddingId;

  FutureOr<RsvpStats> build(String weddingId);
}

/// See also [RsvpStatsController].
@ProviderFor(RsvpStatsController)
const rsvpStatsControllerProvider = RsvpStatsControllerFamily();

/// See also [RsvpStatsController].
class RsvpStatsControllerFamily extends Family<AsyncValue<RsvpStats>> {
  /// See also [RsvpStatsController].
  const RsvpStatsControllerFamily();

  /// See also [RsvpStatsController].
  RsvpStatsControllerProvider call(String weddingId) {
    return RsvpStatsControllerProvider(weddingId);
  }

  @override
  RsvpStatsControllerProvider getProviderOverride(
    covariant RsvpStatsControllerProvider provider,
  ) {
    return call(provider.weddingId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rsvpStatsControllerProvider';
}

/// See also [RsvpStatsController].
class RsvpStatsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<RsvpStatsController, RsvpStats> {
  /// See also [RsvpStatsController].
  RsvpStatsControllerProvider(String weddingId)
    : this._internal(
        () => RsvpStatsController()..weddingId = weddingId,
        from: rsvpStatsControllerProvider,
        name: r'rsvpStatsControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$rsvpStatsControllerHash,
        dependencies: RsvpStatsControllerFamily._dependencies,
        allTransitiveDependencies:
            RsvpStatsControllerFamily._allTransitiveDependencies,
        weddingId: weddingId,
      );

  RsvpStatsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weddingId,
  }) : super.internal();

  final String weddingId;

  @override
  FutureOr<RsvpStats> runNotifierBuild(covariant RsvpStatsController notifier) {
    return notifier.build(weddingId);
  }

  @override
  Override overrideWith(RsvpStatsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RsvpStatsControllerProvider._internal(
        () => create()..weddingId = weddingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weddingId: weddingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RsvpStatsController, RsvpStats>
  createElement() {
    return _RsvpStatsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RsvpStatsControllerProvider && other.weddingId == weddingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weddingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RsvpStatsControllerRef on AutoDisposeAsyncNotifierProviderRef<RsvpStats> {
  /// The parameter `weddingId` of this provider.
  String get weddingId;
}

class _RsvpStatsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<RsvpStatsController, RsvpStats>
    with RsvpStatsControllerRef {
  _RsvpStatsControllerProviderElement(super.provider);

  @override
  String get weddingId => (origin as RsvpStatsControllerProvider).weddingId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
