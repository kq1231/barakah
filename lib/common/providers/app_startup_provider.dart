// filepath: lib/providers/app_startup_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/objectbox_service.dart';

part 'app_startup_provider.g.dart';

/// Enum representing the different states of app initialization
enum AppStartupState {
  initializing,
  initialized,
  error,
}

/// Class to hold both the startup state and any potential error
class AppStartupStatus {
  final AppStartupState state;
  final Object? error;
  final StackTrace? stackTrace;

  const AppStartupStatus.initializing()
      : state = AppStartupState.initializing,
        error = null,
        stackTrace = null;

  const AppStartupStatus.initialized()
      : state = AppStartupState.initialized,
        error = null,
        stackTrace = null;

  const AppStartupStatus.error(this.error, this.stackTrace)
      : state = AppStartupState.error;
}

/// Provider for the ObjectBox store service
@riverpod
Future<ObjectBoxService> objectBoxStore(ref) async {
  return await ObjectBoxService.create();
}

/// Provider that manages the entire app initialization flow
@riverpod
class AppStartup extends _$AppStartup {
  @override
  FutureOr<AppStartupStatus> build() async {
    try {
      // Start with initializing state
      state = const AsyncValue.data(AppStartupStatus.initializing());

      // Initialize the ObjectBox store - we await this to ensure it's ready
      // final objectBoxStore =
      await ref.watch(objectBoxStoreProvider.future);

      // Add any other initialization tasks here
      // For example, loading user preferences, authentication state, etc.

      // Return initialized status
      return const AppStartupStatus.initialized();
    } catch (e, stackTrace) {
      // In case of any errors, return error status
      return AppStartupStatus.error(e, stackTrace);
    }
  }
}
