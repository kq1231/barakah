import 'package:objectbox/objectbox.dart';

@Entity()
class Contact {
  @Id()
  int id = 0;

  String name;
  String type;

  Contact({
    required this.name,
    required this.type,
  });
}
