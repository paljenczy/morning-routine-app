import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/child.dart';
import '../../models/activity.dart';
import '../../providers/children_provider.dart';
import '../../providers/activities_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/animal_avatar.dart';
import '../../utils/activity_label.dart';

const _avatarKeys = ['fox', 'rabbit', 'bear', 'cat', 'dog', 'owl'];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settingsTitle),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabChildren),
              Tab(text: l10n.tabActivities),
            ],
          ),
          actions: [
            // Language toggle
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.languageLabel,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'hu', label: Text('HU')),
                      ButtonSegment(value: 'en', label: Text('EN')),
                    ],
                    selected: {settings.locale.languageCode},
                    onSelectionChanged: (Set<String> sel) {
                      ref.read(settingsProvider.notifier).setLocale(sel.first);
                    },
                    style: const ButtonStyle(
                        visualDensity: VisualDensity.compact),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            const _ChildrenTab(),
            const _ActivitiesTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Children tab ────────────────────────────────────────────────────────────

class _ChildrenTab extends ConsumerWidget {
  const _ChildrenTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final children = ref.watch(childrenProvider);
    final canAdd = children.length < 5;

    return Stack(
      children: [
        children.isEmpty
            ? Center(child: Text(l10n.noChildren))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: children.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _ChildCard(child: children[index]),
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'add_child',
            onPressed: canAdd
                ? () => _showAddChildDialog(context, ref)
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.maxChildrenReached)),
                    ),
            icon: const Icon(Icons.person_add),
            label: Text(l10n.addChild),
            backgroundColor: canAdd ? null : Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddChildDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (_) => _AddChildDialog(ref: ref),
    );
  }
}

class _ChildCard extends ConsumerWidget {
  final Child child;

  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: AnimalAvatar(
          avatarKey: child.avatarKey,
          name: child.name,
          size: 48,
          showName: false,
        ),
        title: Text(child.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                content: Text(l10n.deleteChildConfirm(child.name)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel)),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.confirm)),
                ],
              ),
            );
            if (confirmed == true) {
              ref.read(childrenProvider.notifier).remove(child.id);
            }
          },
        ),
      ),
    );
  }
}

class _AddChildDialog extends StatefulWidget {
  final WidgetRef ref;

  const _AddChildDialog({required this.ref});

  @override
  State<_AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<_AddChildDialog> {
  final _nameController = TextEditingController();
  String _selectedAvatar = _avatarKeys[0];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.addChild),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.childName,
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            _AvatarPicker(
              selected: _selectedAvatar,
              onSelect: (key) => setState(() => _selectedAvatar = key),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              widget.ref
                  .read(childrenProvider.notifier)
                  .add(name, _selectedAvatar);
              Navigator.pop(context);
            }
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _AvatarPicker({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: _avatarKeys.map((key) {
        final isSelected = key == selected;
        return GestureDetector(
          onTap: () => onSelect(key),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimalAvatar(
                avatarKey: key,
                name: key,
                size: 56,
                showName: false,
              ),
              if (isSelected)
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Activities tab ───────────────────────────────────────────────────────────

class _ActivitiesTab extends ConsumerStatefulWidget {
  const _ActivitiesTab();

  @override
  ConsumerState<_ActivitiesTab> createState() => _ActivitiesTabState();
}

class _ActivitiesTabState extends ConsumerState<_ActivitiesTab> {
  final _newActivityController = TextEditingController();
  bool _showAddField = false;

  @override
  void dispose() {
    _newActivityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activities = ref.watch(activitiesProvider);

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: activities.length,
            // ignore: deprecated_member_use
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              ref
                  .read(activitiesProvider.notifier)
                  .reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _ActivityTile(
                key: ValueKey(activity.id),
                activity: activity,
              );
            },
          ),
        ),
        if (_showAddField)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newActivityController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.activityLabel,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addActivity(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: _addActivity, child: Text(l10n.confirm)),
                const SizedBox(width: 4),
                TextButton(
                    onPressed: () =>
                        setState(() => _showAddField = false),
                    child: Text(l10n.cancel)),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l10n.addActivity),
              onPressed: () => setState(() {
                _showAddField = true;
                _newActivityController.clear();
              }),
            ),
          ),
        ),
      ],
    );
  }

  void _addActivity() {
    final label = _newActivityController.text.trim();
    if (label.isNotEmpty) {
      ref.read(activitiesProvider.notifier).add(label);
      _newActivityController.clear();
      setState(() => _showAddField = false);
    }
  }
}

class _ActivityTile extends ConsumerWidget {
  final Activity activity;

  const _ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.drag_handle, color: Colors.grey),
        title: Text(resolveActivityLabel(activity, l10n)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                content: Text(l10n.deleteActivityConfirm),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel)),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.confirm)),
                ],
              ),
            );
            if (confirmed == true) {
              ref.read(activitiesProvider.notifier).remove(activity.id);
            }
          },
        ),
      ),
    );
  }
}
