import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 1)
class Activity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String labelKey;

  @HiveField(2)
  bool isCustom;

  @HiveField(3)
  int sortOrder;

  Activity({
    required this.id,
    required this.labelKey,
    required this.isCustom,
    required this.sortOrder,
  });
}
