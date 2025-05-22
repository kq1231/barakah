// filepath: lib/screens/startup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakah/providers/app_startup_provider.dart';

class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupStatus = ref.watch(appStartupProvider);

    return startupStatus.when(
      data: (status) {
        switch (status.state) {
          case AppStartupState.initializing:
            return _buildLoadingScreen();
          case AppStartupState.initialized:
            return _buildSuccessScreen();
          case AppStartupState.error:
            return _buildErrorScreen(context, status.error, status.stackTrace);
        }
      },
      loading: () => _buildLoadingScreen(),
      error: (error, stackTrace) =>
          _buildErrorScreen(context, error, stackTrace),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', width: 120, height: 120,
                errorBuilder: (context, error, stackTrace) {
              // Fallback if logo is not available
              return const Icon(Icons.account_balance, size: 80);
            }),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Loading Barakah Finance...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    // This is just a placeholder. In reality, you would likely navigate
    // to the main screen of your app rather than displaying this.
    return const Scaffold(
      body: Center(
        child: Text(
          'App successfully initialized!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(
      BuildContext context, Object? error, StackTrace? stackTrace) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Failed to start the app',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.red.shade800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _retryInitialization(context),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryInitialization(BuildContext context) {
    // Access the Riverpod container and refresh the appStartupProvider
    ProviderScope.containerOf(context).refresh(appStartupProvider);
  }
}
