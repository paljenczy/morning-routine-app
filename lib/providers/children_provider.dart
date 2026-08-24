import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/child.dart';
import 'completion_provider.dart';

const _uuid = Uuid();

class ChildrenNotifier extends StateNotifier<List<Child>> {
  final Box<Child> _box;
  final Ref _ref;

  ChildrenNotifier(this._box, this._ref)
      : super(_sortedChildren(_box.values.toList()));

  static List<Child> _sortedChildren(List<Child> children) {
    final sorted = List<Child>.from(children);
    sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted;
  }

  void add(String name, String avatarKey) {
    final child = Child(
      id: _uuid.v4(),
      name: name,
      avatarKey: avatarKey,
      sortOrder: state.length,
    );
    _box.put(child.id, child);
    state = [...state, child];
  }

  void remove(String id) {
    _box.delete(id);
    _ref.read(completionProvider.notifier).purgeChild(id);
    state = state.where((c) => c.id != id).toList();
  }

  void reorder(int oldIndex, int newIndex) {
    final list = List<Child>.from(state);
    final child = list.removeAt(oldIndex);
    list.insert(newIndex, child);
    for (int i = 0; i < list.length; i++) {
      list[i].sortOrder = i;
      list[i].save();
    }
    state = list;
  }
}

final childrenProvider =
    StateNotifierProvider<ChildrenNotifier, List<Child>>((ref) {
  final box = Hive.box<Child>('children');
  return ChildrenNotifier(box, ref);
});
