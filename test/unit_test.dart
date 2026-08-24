import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:morning_routine_app/models/activity.dart';
import 'package:morning_routine_app/models/child.dart';
import 'package:morning_routine_app/models/completion_record.dart';

void main() {
  group('CompletionRecord date key comparison', () {
    test('earlier dateKey sorts before later one', () {
      const earlier = '2026-08-18';
      const later = '2026-08-24';
      expect(earlier.compareTo(later) < 0, isTrue);
    });

    test('same dateKey compares equal', () {
      const date = '2026-08-24';
      expect(date.compareTo(date), 0);
    });
  });

  group('Weekly date calculation', () {
    DateTime startOfWeek(DateTime date) {
      return DateTime(date.year, date.month, date.day - (date.weekday - 1));
    }

    test('Monday of a week is correctly identified', () {
      // 2026-08-24 is a Monday
      final monday = DateTime(2026, 8, 24);
      expect(monday.weekday, 1);
      expect(startOfWeek(monday), monday);
    });

    test('Friday of the same week is 4 days after Monday', () {
      final monday = DateTime(2026, 8, 24);
      final friday = monday.add(const Duration(days: 4));
      expect(friday.weekday, 5);
      expect(friday.day, 28);
    });

    test('startOfWeek on a Wednesday returns the Monday', () {
      final wednesday = DateTime(2026, 8, 26);
      expect(wednesday.weekday, 3);
      final monday = startOfWeek(wednesday);
      expect(monday.weekday, 1);
      expect(monday.day, 24);
    });

    test('week spans 5 days Mon–Fri correctly across month boundary', () {
      // Mon 2026-08-31 → Fri 2026-09-04
      final monday = DateTime(2026, 8, 31);
      expect(monday.weekday, 1);
      final days = List.generate(5, (i) => monday.add(Duration(days: i)));
      expect(days.first.day, 31);
      expect(days.first.month, 8);
      expect(days.last.day, 4);
      expect(days.last.month, 9);
    });

    test('midnight tomorrow construction does not overflow', () {
      // Verifies DateTime(y, m, d+1) works at month end
      final lastDayOfMonth = DateTime(2026, 8, 31);
      final tomorrow = DateTime(
          lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day + 1);
      expect(tomorrow.month, 9);
      expect(tomorrow.day, 1);
    });
  });

  group('Activity label key helpers', () {
    test('default activity keys are recognised', () {
      const keys = [
        'activity_toilet',
        'activity_dressing',
        'activity_breakfast',
        'activity_teeth',
        'activity_bag',
      ];
      for (final key in keys) {
        expect(key.startsWith('activity_'), isTrue);
      }
    });
  });

  group('Hive model construction', () {
    test('Child fields are assigned', () {
      final child = Child(
        id: 'c1',
        name: 'Anna',
        avatarKey: 'fox',
        sortOrder: 0,
      );
      expect(child.id, 'c1');
      expect(child.name, 'Anna');
      expect(child.avatarKey, 'fox');
    });

    test('Activity isCustom flag defaults correctly', () {
      final defaultActivity = Activity(
        id: 'a1',
        labelKey: 'activity_toilet',
        isCustom: false,
        sortOrder: 0,
      );
      final customActivity = Activity(
        id: 'a2',
        labelKey: 'My custom task',
        isCustom: true,
        sortOrder: 1,
      );
      expect(defaultActivity.isCustom, isFalse);
      expect(customActivity.isCustom, isTrue);
    });

    test('CompletionRecord stores childId + activityId + dateKey', () {
      final record = CompletionRecord(
        childId: 'c1',
        activityId: 'a1',
        dateKey: '2026-08-24',
      );
      expect(record.childId, 'c1');
      expect(record.activityId, 'a1');
      expect(record.dateKey, '2026-08-24');
    });
  });

  group('isCompleted logic', () {
    bool isCompleted(
        List<CompletionRecord> records, String childId, String activityId, String dateKey) {
      return records.any((r) =>
          r.childId == childId &&
          r.activityId == activityId &&
          r.dateKey == dateKey);
    }

    bool isChildComplete(
        List<CompletionRecord> records, List<Activity> activities, String childId, String dateKey) {
      if (activities.isEmpty) return false;
      final count = records
          .where((r) => r.childId == childId && r.dateKey == dateKey)
          .length;
      return count >= activities.length;
    }

    final activities = [
      Activity(id: 'a1', labelKey: 'activity_toilet', isCustom: false, sortOrder: 0),
      Activity(id: 'a2', labelKey: 'activity_teeth', isCustom: false, sortOrder: 1),
    ];

    test('empty records → not completed', () {
      expect(isCompleted([], 'c1', 'a1', '2026-08-24'), isFalse);
    });

    test('matching record → completed', () {
      final records = [
        CompletionRecord(childId: 'c1', activityId: 'a1', dateKey: '2026-08-24'),
      ];
      expect(isCompleted(records, 'c1', 'a1', '2026-08-24'), isTrue);
    });

    test('record for different date → not completed', () {
      final records = [
        CompletionRecord(childId: 'c1', activityId: 'a1', dateKey: '2026-08-23'),
      ];
      expect(isCompleted(records, 'c1', 'a1', '2026-08-24'), isFalse);
    });

    test('partial completion → child not complete', () {
      final records = [
        CompletionRecord(childId: 'c1', activityId: 'a1', dateKey: '2026-08-24'),
      ];
      expect(isChildComplete(records, activities, 'c1', '2026-08-24'), isFalse);
    });

    test('all activities done → child complete', () {
      final records = [
        CompletionRecord(childId: 'c1', activityId: 'a1', dateKey: '2026-08-24'),
        CompletionRecord(childId: 'c1', activityId: 'a2', dateKey: '2026-08-24'),
      ];
      expect(isChildComplete(records, activities, 'c1', '2026-08-24'), isTrue);
    });

    test('other child completions do not count', () {
      final records = [
        CompletionRecord(childId: 'c2', activityId: 'a1', dateKey: '2026-08-24'),
        CompletionRecord(childId: 'c2', activityId: 'a2', dateKey: '2026-08-24'),
      ];
      expect(isChildComplete(records, activities, 'c1', '2026-08-24'), isFalse);
    });

    test('empty activity list → never complete', () {
      expect(isChildComplete([], [], 'c1', '2026-08-24'), isFalse);
    });
  });
}
