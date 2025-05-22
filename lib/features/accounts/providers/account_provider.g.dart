// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRepositoryHash() => r'2e3e8354762bcacedf4b1bf333562a696222d6dd';

/// Provider for the AccountRepository
///
/// Copied from [accountRepository].
@ProviderFor(accountRepository)
final accountRepositoryProvider =
    AutoDisposeProvider<AccountRepository>.internal(
  accountRepository,
  name: r'accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRepositoryRef = AutoDisposeProviderRef<AccountRepository>;
String _$accountsByTypeHash() => r'32fb00c2be0f4e4b2422421b7a847fdb4bf89133';

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

/// Provider to get accounts of a specific type
///
/// Copied from [accountsByType].
@ProviderFor(accountsByType)
const accountsByTypeProvider = AccountsByTypeFamily();

/// Provider to get accounts of a specific type
///
/// Copied from [accountsByType].
class AccountsByTypeFamily extends Family<AsyncValue<List<Account>>> {
  /// Provider to get accounts of a specific type
  ///
  /// Copied from [accountsByType].
  const AccountsByTypeFamily();

  /// Provider to get accounts of a specific type
  ///
  /// Copied from [accountsByType].
  AccountsByTypeProvider call(
    String type,
  ) {
    return AccountsByTypeProvider(
      type,
    );
  }

  @override
  AccountsByTypeProvider getProviderOverride(
    covariant AccountsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'accountsByTypeProvider';
}

/// Provider to get accounts of a specific type
///
/// Copied from [accountsByType].
class AccountsByTypeProvider extends AutoDisposeFutureProvider<List<Account>> {
  /// Provider to get accounts of a specific type
  ///
  /// Copied from [accountsByType].
  AccountsByTypeProvider(
    String type,
  ) : this._internal(
          (ref) => accountsByType(
            ref as AccountsByTypeRef,
            type,
          ),
          from: accountsByTypeProvider,
          name: r'accountsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountsByTypeHash,
          dependencies: AccountsByTypeFamily._dependencies,
          allTransitiveDependencies:
              AccountsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  AccountsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    FutureOr<List<Account>> Function(AccountsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountsByTypeProvider._internal(
        (ref) => create(ref as AccountsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Account>> createElement() {
    return _AccountsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountsByTypeRef on AutoDisposeFutureProviderRef<List<Account>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _AccountsByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<Account>>
    with AccountsByTypeRef {
  _AccountsByTypeProviderElement(super.provider);

  @override
  String get type => (origin as AccountsByTypeProvider).type;
}

String _$accountHash() => r'381737f460330ece6aaf731fd911bc2bd67d554f';

/// Provider for a single account by ID
///
/// Copied from [account].
@ProviderFor(account)
const accountProvider = AccountFamily();

/// Provider for a single account by ID
///
/// Copied from [account].
class AccountFamily extends Family<AsyncValue<Account?>> {
  /// Provider for a single account by ID
  ///
  /// Copied from [account].
  const AccountFamily();

  /// Provider for a single account by ID
  ///
  /// Copied from [account].
  AccountProvider call(
    int id,
  ) {
    return AccountProvider(
      id,
    );
  }

  @override
  AccountProvider getProviderOverride(
    covariant AccountProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'accountProvider';
}

/// Provider for a single account by ID
///
/// Copied from [account].
class AccountProvider extends AutoDisposeFutureProvider<Account?> {
  /// Provider for a single account by ID
  ///
  /// Copied from [account].
  AccountProvider(
    int id,
  ) : this._internal(
          (ref) => account(
            ref as AccountRef,
            id,
          ),
          from: accountProvider,
          name: r'accountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountHash,
          dependencies: AccountFamily._dependencies,
          allTransitiveDependencies: AccountFamily._allTransitiveDependencies,
          id: id,
        );

  AccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Account?> Function(AccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProvider._internal(
        (ref) => create(ref as AccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Account?> createElement() {
    return _AccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountRef on AutoDisposeFutureProviderRef<Account?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AccountProviderElement extends AutoDisposeFutureProviderElement<Account?>
    with AccountRef {
  _AccountProviderElement(super.provider);

  @override
  int get id => (origin as AccountProvider).id;
}

String _$accountBalanceHash() => r'204ef43c8fba580b6df0f61281328330ed7f3716';

/// Provider for account balance
///
/// Copied from [accountBalance].
@ProviderFor(accountBalance)
const accountBalanceProvider = AccountBalanceFamily();

/// Provider for account balance
///
/// Copied from [accountBalance].
class AccountBalanceFamily extends Family<AsyncValue<double>> {
  /// Provider for account balance
  ///
  /// Copied from [accountBalance].
  const AccountBalanceFamily();

  /// Provider for account balance
  ///
  /// Copied from [accountBalance].
  AccountBalanceProvider call(
    int accountId,
  ) {
    return AccountBalanceProvider(
      accountId,
    );
  }

  @override
  AccountBalanceProvider getProviderOverride(
    covariant AccountBalanceProvider provider,
  ) {
    return call(
      provider.accountId,
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
  String? get name => r'accountBalanceProvider';
}

/// Provider for account balance
///
/// Copied from [accountBalance].
class AccountBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// Provider for account balance
  ///
  /// Copied from [accountBalance].
  AccountBalanceProvider(
    int accountId,
  ) : this._internal(
          (ref) => accountBalance(
            ref as AccountBalanceRef,
            accountId,
          ),
          from: accountBalanceProvider,
          name: r'accountBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountBalanceHash,
          dependencies: AccountBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountBalanceFamily._allTransitiveDependencies,
          accountId: accountId,
        );

  AccountBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  Override overrideWith(
    FutureOr<double> Function(AccountBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountBalanceProvider._internal(
        (ref) => create(ref as AccountBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _AccountBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountBalanceProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _AccountBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double> with AccountBalanceRef {
  _AccountBalanceProviderElement(super.provider);

  @override
  int get accountId => (origin as AccountBalanceProvider).accountId;
}

String _$accountsNotifierHash() => r'3da0ca049d1eb675ab465969d6411bca788b5d6a';

/// Provider for managing the list of accounts
///
/// Copied from [AccountsNotifier].
@ProviderFor(AccountsNotifier)
final accountsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AccountsNotifier, List<Account>>.internal(
  AccountsNotifier.new,
  name: r'accountsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsNotifier = AutoDisposeAsyncNotifier<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
