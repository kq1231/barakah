import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakah/design_system/templates/accounts_template.dart';
import 'account_detail_screen.dart';
import 'add_account_screen.dart';
import '../controllers/accounts_screen_controller.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  AccountSortOption _currentSortOption = AccountSortOption.nameAsc;

  @override
  Widget build(BuildContext context) {
    final accountViewModelsAsync =
        ref.watch(sortedAccountViewModelsProvider(_currentSortOption));
    final netWorthAsync = ref.watch(netWorthProvider);

    return accountViewModelsAsync.when(
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error: (error, stackTrace) => Scaffold(
              body: Center(child: Text('Error: $error')),
            ),
        data: (accountsMap) {
          // Transform the data for display
          final accountTypes = <AccountTypeSummaryData>[];

          // Process assets
          final assetAccounts = accountsMap['asset'] ?? [];
          if (assetAccounts.isNotEmpty) {
            final assetAccountsData =
                assetAccounts.map((vm) => vm.toAccountData()).toList();

            accountTypes.add(
              AccountTypeSummaryData(
                type: 'Assets',
                total: assetAccounts.fold(0, (sum, vm) => sum + vm.balance),
                accounts: assetAccountsData,
                isPositiveBalance: true,
              ),
            );
          }

          // Process liabilities
          final liabilityAccounts = accountsMap['liability'] ?? [];
          if (liabilityAccounts.isNotEmpty) {
            final liabilityAccountsData =
                liabilityAccounts.map((vm) => vm.toAccountData()).toList();

            accountTypes.add(
              AccountTypeSummaryData(
                type: 'Liabilities',
                total: liabilityAccounts.fold(0, (sum, vm) => sum + vm.balance),
                accounts: liabilityAccountsData,
                isPositiveBalance: false,
              ),
            );
          }

          // Get the net worth value
          final netWorth = netWorthAsync.maybeWhen(
            data: (value) => value,
            orElse: () => 0.0,
          );

          return AccountsTemplate(
            netWorth: netWorth,
            asOfDate: DateTime.now(),
            accountTypes: accountTypes,
            onAccountTap: (account) {
              // Find the account ID from the view models
              int? accountId;
              for (final accountList in accountsMap.values) {
                for (final vm in accountList) {
                  if (vm.toAccountData().name == account.name) {
                    accountId = vm.account.id;
                    break;
                  }
                }
                if (accountId != null) break;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AccountDetailScreen(
                    accountName: account.name,
                    balance: account.balance,
                    accountId: accountId,
                  ),
                ),
              );
            },
            onAddAccount: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddAccountScreen(),
                ),
              );
            },
            onSortChanged: (sortOption) {
              setState(() {
                _currentSortOption = sortOption;
              });
            },
            onInfoTap: () {
              // Show info about net worth calculation
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Net Worth'),
                  content: const Text(
                    'Net worth is calculated as the sum of all assets minus liabilities. It represents your overall financial position.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
