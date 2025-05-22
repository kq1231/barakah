// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountViewModelsHash() => r'd8364c142025b17fea982cc71515163e6aaf066d';

/// Provider for accounts view models, organized by type
///
/// Copied from [accountViewModels].
@ProviderFor(accountViewModels)
final accountViewModelsProvider =
    AutoDisposeFutureProvider<Map<String, List<AccountViewModel>>>.internal(
  accountViewModels,
  name: r'accountViewModelsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountViewModelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountViewModelsRef
    = AutoDisposeFutureProviderRef<Map<String, List<AccountViewModel>>>;
String _$sortedAccountViewModelsHash() =>
    r'28fcc28ea995c492d8d133d30fbfd8979f14f57e';

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

/// Provider for sorted account view models
///
/// Copied from [sortedAccountViewModels].
@ProviderFor(sortedAccountViewModels)
const sortedAccountViewModelsProvider = SortedAccountViewModelsFamily();

/// Provider for sorted account view models
///
/// Copied from [sortedAccountViewModels].
class SortedAccountViewModelsFamily
    extends Family<AsyncValue<Map<String, List<AccountViewModel>>>> {
  /// Provider for sorted account view models
  ///
  /// Copied from [sortedAccountViewModels].
  const SortedAccountViewModelsFamily();

  /// Provider for sorted account view models
  ///
  /// Copied from [sortedAccountViewModels].
  SortedAccountViewModelsProvider call(
    AccountSortOption sortOption,
  ) {
    return SortedAccountViewModelsProvider(
      sortOption,
    );
  }

  @override
  SortedAccountViewModelsProvider getProviderOverride(
    covariant SortedAccountViewModelsProvider provider,
  ) {
    return call(
      provider.sortOption,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sortedAccountViewModelsProvider';
}

/// Provider for sorted account view models
///
/// Copied from [sortedAccountViewModels].
class SortedAccountViewModelsProvider
    extends AutoDisposeFutureProvider<Map<String, List<AccountViewModel>>> {
  /// Provider for sorted account view models
  ///
  /// Copied from [sortedAccountViewModels].
  SortedAccountViewModelsProvider(
    AccountSortOption sortOption,
  ) : this._internal(
          (ref) => sortedAccountViewModels(
            ref as SortedAccountViewModelsRef,
            sortOption,
          ),
          from: sortedAccountViewModelsProvider,
          name: r'sortedAccountViewModelsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedAccountViewModelsHash,
          dependencies: SortedAccountViewModelsFamily._dependencies,
          allTransitiveDependencies:
              SortedAccountViewModelsFamily._allTransitiveDependencies,
          sortOption: sortOption,
        );

  SortedAccountViewModelsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sortOption,
  }) : super.internal();

  final AccountSortOption sortOption;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<AccountViewModel>>> Function(
            SortedAccountViewModelsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedAccountViewModelsProvider._internal(
        (ref) => create(ref as SortedAccountViewModelsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sortOption: sortOption,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<AccountViewModel>>>
      createElement() {
    return _SortedAccountViewModelsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedAccountViewModelsProvider &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sortOption.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortedAccountViewModelsRef
    on AutoDisposeFutureProviderRef<Map<String, List<AccountViewModel>>> {
  /// The parameter `sortOption` of this provider.
  AccountSortOption get sortOption;
}

class _SortedAccountViewModelsProviderElement
    extends AutoDisposeFutureProviderElement<
        Map<String, List<AccountViewModel>>> with SortedAccountViewModelsRef {
  _SortedAccountViewModelsProviderElement(super.provider);

  @override
  AccountSortOption get sortOption =>
      (origin as SortedAccountViewModelsProvider).sortOption;
}

String _$netWorthHash() => r'8952ca50ad79ba1e5df751769f499ec353effa2b';

/// Provider for net worth calculation
///
/// Copied from [netWorth].
@ProviderFor(netWorth)
final netWorthProvider = AutoDisposeFutureProvider<double>.internal(
  netWorth,
  name: r'netWorthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$netWorthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetWorthRef = AutoDisposeFutureProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
