// filepath: lib/features/accounts/providers/account_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/account.dart';
import '../repositories/account_repository.dart';
import '../../../common/providers/app_startup_provider.dart';

part 'account_provider.g.dart';

/// Provider for the AccountRepository
@riverpod
AccountRepository accountRepository(ref) {
  final store = ref.watch(objectBoxStoreProvider).value!.store;
  return AccountRepository(store);
}

/// Provider for managing the list of accounts
@riverpod
class AccountsNotifier extends _$AccountsNotifier {
  @override
  Future<List<Account>> build() async {
    final repository = ref.watch(accountRepositoryProvider);
    return repository.getAllAccounts();
  }

  /// Create a new account
  Future<void> createAccount(Account account) async {
    final repository = ref.read(accountRepositoryProvider);
    await repository.createAccount(account);
    ref.invalidateSelf();
  }

  /// Update an existing account
  Future<void> updateAccount(Account account) async {
    final repository = ref.read(accountRepositoryProvider);
    await repository.updateAccount(account);
    ref.invalidateSelf();
  }

  /// Delete an account
  Future<void> deleteAccount(int id) async {
    final repository = ref.read(accountRepositoryProvider);
    final hasTransactions = await repository.hasTransactions(id);

    if (hasTransactions) {
      throw Exception('Cannot delete an account with transactions');
    }

    repository.deleteAccount(id);
    ref.invalidateSelf();
  }
}

/// Provider to get accounts of a specific type
@riverpod
Future<List<Account>> accountsByType(
  ref,
  String type,
) async {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.getAccountsByType(type);
}

/// Provider for a single account by ID
@riverpod
Future<Account?> account(ref, int id) async {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.getAccountById(id);
}

/// Provider for account balance
@riverpod
Future<double> accountBalance(ref, int accountId) async {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.getAccountBalance(accountId);
}
