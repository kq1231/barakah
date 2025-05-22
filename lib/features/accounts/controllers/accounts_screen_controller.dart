// filepath: lib/features/accounts/controllers/accounts_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:barakah/design_system/templates/accounts_template.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

part 'accounts_screen_controller.g.dart';

/// Model for account with balance information
class AccountViewModel {
  final Account account;
  final double balance;
  final IconData icon;

  AccountViewModel({
    required this.account,
    required this.balance,
    required this.icon,
  });

  // Convert to AccountData for UI template
  AccountData toAccountData() {
    return AccountData(
      name: account.name,
      balance: balance,
      icon: icon,
      institution:
          account.parent.target != null ? account.parent.target!.name : '',
      accountNumber: 'ACCT-${account.id}',
    );
  }
}

/// Provider for accounts view models, organized by type
@riverpod
Future<Map<String, List<AccountViewModel>>> accountViewModels(ref) async {
  // Get all accounts
  final accounts = await ref.watch(accountsNotifierProvider.future);

  // Group by type
  final result = <String, List<AccountViewModel>>{};

  // Process each account
  for (final account in accounts) {
    // Get balance for this account
    final balance = await ref.read(accountBalanceProvider(account.id).future);

    // Determine icon based on account type
    final icon = _getIconForAccountType(account.type);

    // Create view model
    final viewModel = AccountViewModel(
      account: account,
      balance: balance,
      icon: icon,
    );

    // Add to appropriate group
    final type = account.type;
    if (!result.containsKey(type)) {
      result[type] = [];
    }
    result[type]!.add(viewModel);
  }

  return result;
}

/// Provider for sorted account view models
@riverpod
Future<Map<String, List<AccountViewModel>>> sortedAccountViewModels(
  ref,
  AccountSortOption sortOption,
) async {
  // Get the base account view models
  final viewModels = await ref.watch(accountViewModelsProvider.future);

  // Create a copy to modify
  final result = <String, List<AccountViewModel>>{};

  // Copy each list with sorting applied
  for (final entry in viewModels.entries) {
    final key = entry.key;
    final accounts = List<AccountViewModel>.from(entry.value);

    // Apply sorting
    switch (sortOption) {
      case AccountSortOption.nameAsc:
        accounts.sort((a, b) => a.account.name.compareTo(b.account.name));
        break;
      case AccountSortOption.nameDesc:
        accounts.sort((a, b) => b.account.name.compareTo(a.account.name));
        break;
      case AccountSortOption.balanceAsc:
        accounts.sort((a, b) => a.balance.compareTo(b.balance));
        break;
      case AccountSortOption.balanceDesc:
        accounts.sort((a, b) => b.balance.compareTo(a.balance));
        break;
      case AccountSortOption.institution:
        accounts.sort((a, b) {
          final aInst = a.account.parent.target?.name ?? '';
          final bInst = b.account.parent.target?.name ?? '';
          return aInst.compareTo(bInst);
        });
        break;
    }

    result[key] = accounts;
  }

  return result;
}

/// Provider for net worth calculation
@riverpod
Future<double> netWorth(ref) async {
  final accountsMap = await ref.watch(accountViewModelsProvider.future);

  double assets = 0;
  double liabilities = 0;

  // Sum up assets and liabilities
  for (final entry in accountsMap.entries) {
    final type = entry.key;
    final accounts = entry.value;

    if (type.toLowerCase() == 'asset') {
      assets += accounts.fold(0, (sum, account) => sum + account.balance);
    } else if (type.toLowerCase() == 'liability') {
      liabilities += accounts.fold(0, (sum, account) => sum + account.balance);
    }
  }

  return assets - liabilities;
}

// Helper to determine icon based on account type
IconData _getIconForAccountType(String type) {
  final lowerType = type.toLowerCase();

  // Initial mapping - can be expanded
  return switch (lowerType) {
    'asset' => IconData(0xe25c, fontFamily: 'MaterialIcons'), // account_balance
    'liability' => IconData(0xe8b8, fontFamily: 'MaterialIcons'), // credit_card
    'income' => IconData(0xe8dc, fontFamily: 'MaterialIcons'), // trending_up
    'expense' => IconData(0xe8e3, fontFamily: 'MaterialIcons'), // trending_down
    'capital' => IconData(0xe263, fontFamily: 'MaterialIcons'), // savings
    _ => IconData(0xe3b7, fontFamily: 'MaterialIcons'), // account_circle
  };
}
