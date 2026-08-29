import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/completion_record.dart';
import 'activities_provider.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

String _cutoffDateKey() {
  final cutoff = DateTime.now().subtract(const Duration(days: 14));
  return _dateFormat.format(cutoff);
}

class CompletionNotifier extends StateNotifier<List<CompletionRecord>> {
  final Box<CompletionRecord> _box;

  CompletionNotifier(this._box) : super(_box.values.toList()) {
    _pruneOld();
  }

  void _pruneOld() {
    final cutoff = _cutoffDateKey();
    final toDelete = _box.values
        .where((r) => r.dateKey.compareTo(cutoff) < 0)
        .map((r) => r.key)
        .toList();
    _box.deleteAll(toDelete);
    state = _box.values.toList();
  }

  void toggle(String childId, String activityId, String dateKey) {
    final existing = state.where((r) =>
        r.childId == childId &&
        r.activityId == activityId &&
        r.dateKey == dateKey);

    if (existing.isNotEmpty) {
      final key = existing.first.key;
      _box.delete(key);
    } else {
      final record = CompletionRecord(
        childId: childId,
        activityId: activityId,
        dateKey: dateKey,
      );
      _box.add(record);
    }
    state = _box.values.toList();
  }

  bool isCompleted(String childId, String activityId, String dateKey) {
    return state.any((r) =>
        r.childId == childId &&
        r.activityId == activityId &&
        r.dateKey == dateKey);
  }

  void purgeChild(String childId) {
    final toDelete = _box.values
        .where((r) => r.childId == childId)
        .map((r) => r.key)
        .toList();
    _box.deleteAll(toDelete);
    state = _box.values.toList();
  }

  void purgeActivity(String activityId) {
    final toDelete = _box.values
        .where((r) => r.activityId == activityId)
        .map((r) => r.key)
        .toList();
    _box.deleteAll(toDelete);
    state = _box.values.toList();
  }
}

final completionProvider =
    StateNotifierProvider<CompletionNotifier, List<CompletionRecord>>((ref) {
  final box = Hive.box<CompletionRecord>('completions');
  return CompletionNotifier(box);
});

// Fires at every calendar midnight so todayProvider rebuilds
final midnightResetProvider = StreamProvider<void>((ref) async* {
  while (true) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    await Future.delayed(tomorrow.difference(now));
    yield null;
  }
});

final todayProvider = Provider<String>((ref) {
  ref.watch(midnightResetProvider);
  return _dateFormat.format(DateTime.now());
});

// ({childId, date}) -> bool: all activities completed for that child+date
final isChildCompleteProvider =
    Provider.family<bool, ({String childId, String date})>((ref, args) {
  final completions = ref.watch(completionProvider);
  final activities = ref.watch(activitiesProvider);
  if (activities.isEmpty) return false;
  final count = completions
      .where((r) => r.childId == args.childId && r.dateKey == args.date)
      .length;
  return count >= activities.length;
});

// childId -> WeeklyStar: weekdays done = weekStar, all 7 days done = superStar
enum WeeklyStar { none, weekStar, superStar }

final weeklyStarProvider = Provider.family<WeeklyStar, String>((ref, childId) {
  final now = DateTime.now();
  final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));

  // Check Mon–Fri
  bool weekdaysDone = true;
  for (int i = 0; i < 5; i++) {
    final dateKey = _dateFormat.format(monday.add(Duration(days: i)));
    if (!ref.watch(isChildCompleteProvider((childId: childId, date: dateKey)))) {
      weekdaysDone = false;
      break;
    }
  }
  if (!weekdaysDone) return WeeklyStar.none;

  // Check Sat + Sun
  final satKey = _dateFormat.format(monday.add(const Duration(days: 5)));
  final sunKey = _dateFormat.format(monday.add(const Duration(days: 6)));
  final satDone = ref.watch(isChildCompleteProvider((childId: childId, date: satKey)));
  final sunDone = ref.watch(isChildCompleteProvider((childId: childId, date: sunKey)));

  return (satDone && sunDone) ? WeeklyStar.superStar : WeeklyStar.weekStar;
});
