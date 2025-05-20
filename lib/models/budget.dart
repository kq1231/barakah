import 'package:objectbox/objectbox.dart';
import 'account.dart';

@Entity()
class Budget {
  @Id()
  int id = 0;

  String name;
  final account = ToOne<Account>();
  double amount;
  String? rrule;
  String? notes;

  Budget({
    required this.name,
    required this.amount,
    this.rrule,
    this.notes,
  });
}
