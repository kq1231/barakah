import 'package:objectbox/objectbox.dart';
import 'package:barakah/features/contacts/models/contact.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  String date;
  String? description;
  String? reference;

  final contact = ToOne<Contact>();

  Transaction({
    required this.date,
    this.description,
    this.reference,
  });
}
