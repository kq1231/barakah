import 'package:objectbox/objectbox.dart';

@Entity()
class Account {
  @Id()
  int id = 0;

  String name;
  String type; // 'asset', 'liability', 'income', 'expense', 'capital'

  final parent = ToOne<Account>();

  Account({
    required this.name,
    required this.type,
  });
}
