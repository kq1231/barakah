import 'package:objectbox/objectbox.dart';
import '../../transactions/models/transaction.dart';
import '../../accounts/models/account.dart';
import '../../categories/models/category.dart';

@Entity()
class Entry {
  @Id()
  int id = 0;

  /// The parent transaction this entry belongs to
  final transaction = ToOne<Transaction>();

  /// The account this entry affects
  final account = ToOne<Account>();

  /// The category for this entry (optional)
  final category = ToOne<Category>();

  /// The amount of the entry
  double amount;

  /// Whether this is a debit (true) or credit (false) entry
  bool isDebit;

  /// Optional description specific to this entry
  String? description;

  /// Optional note for reconciliation or audit purposes
  String? reconciliationNote;

  Entry({
    required this.amount,
    required this.isDebit,
    this.description,
    this.reconciliationNote,
  });

  /// Helper method to determine if this entry affects asset/expense accounts
  bool get isAssetOrExpenseEntry {
    final accountType = account.target?.type.toLowerCase() ?? '';
    return accountType == 'asset' || accountType == 'expense';
  }

  /// Helper method to get the effect on the account balance
  /// Returns positive for increases, negative for decreases
  double getBalanceEffect() {
    if (isAssetOrExpenseEntry) {
      // For asset/expense accounts:
      // Debits increase, Credits decrease
      return isDebit ? amount : -amount;
    } else {
      // For liability/income/capital accounts:
      // Credits increase, Debits decrease
      return isDebit ? -amount : amount;
    }
  }
}
