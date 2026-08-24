import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 0)
class Child extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String avatarKey;

  @HiveField(3)
  int sortOrder;

  Child({
    required this.id,
    required this.name,
    required this.avatarKey,
    required this.sortOrder,
  });
}
