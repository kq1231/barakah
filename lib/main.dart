import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/transactions/screens/transaction_list_screen.dart';
import 'features/accounts/screens/accounts_screen.dart';
import 'features/budgets/screens/budget_screen.dart';
import 'features/reports/screens/reports_screen.dart';
import 'features/savings/screens/savings_screen.dart';
import 'common/screens/startup_screen.dart';
import 'common/providers/app_startup_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app wrapped with ProviderScope for Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(appStartupProvider);

    return MaterialApp(
      title: 'Barakah Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.teal,
        ),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 56,
          indicatorColor: Colors.green.withValues(alpha: 0.1),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 28.0);
            }
            return const IconThemeData(size: 24.0);
          }),
        ),
      ),
      home: startupState.when(
        data: (status) {
          // Once initialization is complete, show the main home screen
          if (status.state == AppStartupState.initialized) {
            return const HomeScreen();
          }
          // Otherwise show the startup screen which handles loading and error states
          return const StartupScreen();
        },
        loading: () => const StartupScreen(),
        error: (_, __) => const StartupScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionListScreen(),
    const AccountsScreen(),
    const BudgetScreen(),
    const ReportsScreen(),
    const SavingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
        ],
      ),
    );
  }
}
