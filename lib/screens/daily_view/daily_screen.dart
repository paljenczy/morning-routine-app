import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/children_provider.dart';
import '../../providers/activities_provider.dart';
import '../../providers/completion_provider.dart';
import '../../models/child.dart';
import '../../models/activity.dart';
import '../../widgets/animal_avatar.dart';
import '../../widgets/star_icon.dart';
import '../../utils/activity_label.dart';

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final children = ref.watch(childrenProvider);
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.calendar_view_week),
            label: Text(l10n.navWeekly),
            onPressed: () => context.push('/weekly'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.settings),
            label: Text(l10n.navSettings),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: children.isEmpty
          ? Center(child: Text(l10n.noChildren))
          : activities.isEmpty
              ? Center(child: Text(l10n.noActivities))
              : _ChildrenGrid(children: children, activities: activities),
    );
  }
}

class _ChildrenGrid extends ConsumerWidget {
  final List<Child> children;
  final List<Activity> activities;

  const _ChildrenGrid({required this.children, required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map((child) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChildColumn(
                        child: child, activities: activities),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class ChildColumn extends ConsumerWidget {
  final Child child;
  final List<Activity> activities;

  const ChildColumn({super.key, required this.child, required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final isComplete = ref.watch(
        isChildCompleteProvider((childId: child.id, date: today)));

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AnimalAvatar(
            avatarKey: child.avatarKey,
            name: child.name,
            size: 64,
          ),
        ),
        const Divider(height: 1),
        // Activity cells
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: activities.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              return ActivityCell(
                child: child,
                activity: activities[index],
                dateKey: today,
              );
            },
          ),
        ),
        // Star footer
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedStar(filled: isComplete, size: 56),
        ),
      ],
    );
  }
}

class ActivityCell extends ConsumerWidget {
  final Child child;
  final Activity activity;
  final String dateKey;

  const ActivityCell({
    super.key,
    required this.child,
    required this.activity,
    required this.dateKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final completions = ref.watch(completionProvider);
    final isCompleted = completions.any((r) =>
        r.childId == child.id &&
        r.activityId == activity.id &&
        r.dateKey == dateKey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4CAF50)
              : Colors.grey.shade200,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref
              .read(completionProvider.notifier)
              .toggle(child.id, activity.id, dateKey);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isCompleted
                    ? const Icon(Icons.check_circle,
                        key: ValueKey('check'), color: Color(0xFF4CAF50), size: 28)
                    : Icon(Icons.radio_button_unchecked,
                        key: const ValueKey('empty'),
                        color: Colors.grey.shade400,
                        size: 28),
              ),
              const SizedBox(width: 10),
              Icon(
                resolveActivityIcon(activity),
                size: 22,
                color: isCompleted
                    ? const Color(0xFF4CAF50)
                    : Colors.grey.shade500,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resolveActivityLabel(activity, l10n),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF212121),
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
