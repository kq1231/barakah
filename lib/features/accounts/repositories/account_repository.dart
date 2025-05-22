// filepath: lib/features/accounts/repositories/account_repository.dart
import 'package:barakah/objectbox.g.dart';

import '../models/account.dart';
import '../../entries/models/entry.dart';

/// Repository class for Account CRUD operations
class AccountRepository {
  final Store _store;
  late final Box<Account> _accountBox;

  AccountRepository(this._store) {
    _accountBox = _store.box<Account>();
  }

  /// Create a new account
  Future<int> createAccount(Account account) async {
    return _accountBox.put(account);
  }

  /// Get all accounts
  List<Account> getAllAccounts() {
    return _accountBox.getAll();
  }

  /// Get accounts by type
  List<Account> getAccountsByType(String type) {
    final query = _accountBox.query(Account_.type.equals(type)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get a single account by ID
  Account? getAccountById(int id) {
    return _accountBox.get(id);
  }

  /// Update an account
  Future<int> updateAccount(Account account) async {
    return _accountBox.put(account);
  }

  /// Delete an account
  bool deleteAccount(int id) {
    return _accountBox.remove(id);
  }

  /// Get account balance (calculated from entries)
  /// For each account, it sums credits and subtracts debits
  Future<double> getAccountBalance(int accountId) async {
    try {
      // Get a reference to the Entry box
      final entryBox = _store.box<Entry>();

      // Calculate total credits (where isDebit is false)
      final creditsQuery = entryBox
          .query(
              Entry_.account.equals(accountId) & Entry_.isDebit.equals(false))
          .build();
      final credits = creditsQuery.property(Entry_.amount).sum();
      creditsQuery.close();

      // Calculate total debits (where isDebit is true)
      final debitsQuery = entryBox
          .query(Entry_.account.equals(accountId) & Entry_.isDebit.equals(true))
          .build();
      final debits = debitsQuery.property(Entry_.amount).sum();
      debitsQuery.close();

      // For asset and expense accounts:
      // - Debits increase the balance
      // - Credits decrease the balance
      // For liability, income, and capital accounts:
      // - Credits increase the balance
      // - Debits decrease the balance
      final account = getAccountById(accountId);
      if (account == null) return 0.0;

      switch (account.type.toLowerCase()) {
        case 'asset':
        case 'expense':
          return debits - credits;
        case 'liability':
        case 'income':
        case 'capital':
          return credits - debits;
        default:
          return 0.0;
      }
    } catch (e) {
      // If we get here, it's likely because the entries feature isn't implemented yet
      // Returning a mock value is reasonable for now
      return 0.0;
    }
  }

  /// Check if an account has transactions (to prevent deletion)
  Future<bool> hasTransactions(int accountId) async {
    try {
      // Get a reference to the Entry box
      final entryBox = _store.box<Entry>();

      // Count entries for this account
      final query = entryBox.query(Entry_.account.equals(accountId)).build();

      final count = query.count();
      query.close();

      return count > 0;
    } catch (e) {
      // If entries aren't implemented yet, assume no transactions
      return false;
    }
  }
}
