import 'package:objectbox/objectbox.dart';
import '../../transactions/models/transaction.dart';
import '../../accounts/models/account.dart';

@Entity()
class Entry {
  @Id()
  int id = 0;

  final transaction = ToOne<Transaction>();
  final account = ToOne<Account>();

  double amount;
  bool isDebit;
  int? categoryId;

  Entry({
    required this.amount,
    required this.isDebit,
    this.categoryId,
  });
}
