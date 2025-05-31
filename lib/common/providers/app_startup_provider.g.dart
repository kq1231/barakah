// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_startup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$objectBoxStoreHash() => r'f8c68ff423d1a603f60c4fd1a9240ab08326d1fd';

/// Provider for the ObjectBox store service
///
/// Copied from [objectBoxStore].
@ProviderFor(objectBoxStore)
final objectBoxStoreProvider =
    AutoDisposeFutureProvider<ObjectBoxService>.internal(
  objectBoxStore,
  name: r'objectBoxStoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$objectBoxStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObjectBoxStoreRef = AutoDisposeFutureProviderRef<ObjectBoxService>;
String _$appStartupHash() => r'f955552dc99130553c41cc012d502ed4fa59cbd5';

/// Provider that manages the entire app initialization flow
///
/// Copied from [AppStartup].
@ProviderFor(AppStartup)
final appStartupProvider =
    AutoDisposeAsyncNotifierProvider<AppStartup, AppStartupStatus>.internal(
  AppStartup.new,
  name: r'appStartupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStartupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppStartup = AutoDisposeAsyncNotifier<AppStartupStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
