import 'package:objectbox/objectbox.dart';
import 'package:barakah/features/accounts/models/account.dart';

@Entity()
class SavingGoal {
  @Id()
  int id = 0;

  String name;
  double targetAmount;
  double currentAmount;
  String? targetDate;
  final savingAccount = ToOne<Account>();
  String? notes;
  bool isArchived;
  String? rrule;
  double? recurringAmount;

  SavingGoal({
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.targetDate,
    this.notes,
    this.isArchived = false,
    this.rrule,
    this.recurringAmount,
  });
}
