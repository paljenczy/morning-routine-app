import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/activity.dart';
import 'completion_provider.dart';

const _uuid = Uuid();

const _defaultActivityKeys = [
  'activity_toilet',
  'activity_dressing',
  'activity_breakfast',
  'activity_teeth',
  'activity_bag',
];

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  final Box<Activity> _box;
  final Ref _ref;

  ActivitiesNotifier(this._box, this._ref)
      : super(_sortedActivities(_box.values.toList())) {
    _seedIfFirstLaunch();
  }

  static List<Activity> _sortedActivities(List<Activity> activities) {
    final sorted = List<Activity>.from(activities);
    sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted;
  }

  Future<void> _seedIfFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('first_launch') ?? true;
    if (firstLaunch && _box.isEmpty) {
      for (int i = 0; i < _defaultActivityKeys.length; i++) {
        final activity = Activity(
          id: _uuid.v4(),
          labelKey: _defaultActivityKeys[i],
          isCustom: false,
          sortOrder: i,
        );
        _box.put(activity.id, activity);
      }
      await prefs.setBool('first_launch', false);
      state = _sortedActivities(_box.values.toList());
    }
  }

  void add(String label) {
    final activity = Activity(
      id: _uuid.v4(),
      labelKey: label,
      isCustom: true,
      sortOrder: state.length,
    );
    _box.put(activity.id, activity);
    state = [...state, activity];
  }

  void remove(String id) {
    _box.delete(id);
    _ref.read(completionProvider.notifier).purgeActivity(id);
    state = state.where((a) => a.id != id).toList();
  }

  void reorder(int oldIndex, int newIndex) {
    final list = List<Activity>.from(state);
    final activity = list.removeAt(oldIndex);
    list.insert(newIndex, activity);
    for (int i = 0; i < list.length; i++) {
      list[i].sortOrder = i;
      list[i].save();
    }
    state = list;
  }
}

final activitiesProvider =
    StateNotifierProvider<ActivitiesNotifier, List<Activity>>((ref) {
  final box = Hive.box<Activity>('activities');
  return ActivitiesNotifier(box, ref);
});
