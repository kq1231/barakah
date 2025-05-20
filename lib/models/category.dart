import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id = 0;

  String name;
  String type;

  Category({
    required this.name,
    required this.type,
  });
}
