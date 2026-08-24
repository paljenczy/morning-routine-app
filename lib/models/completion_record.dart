import 'package:hive/hive.dart';

part 'completion_record.g.dart';

@HiveType(typeId: 2)
class CompletionRecord extends HiveObject {
  @HiveField(0)
  final String childId;

  @HiveField(1)
  final String activityId;

  @HiveField(2)
  final String dateKey;

  CompletionRecord({
    required this.childId,
    required this.activityId,
    required this.dateKey,
  });
}
