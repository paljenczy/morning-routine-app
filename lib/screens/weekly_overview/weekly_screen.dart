import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/child.dart';
import '../../providers/children_provider.dart';
import '../../providers/completion_provider.dart';
import '../../widgets/animal_avatar.dart';
import '../../widgets/star_icon.dart';

final _dateFmt = DateFormat('yyyy-MM-dd');

class WeeklyScreen extends ConsumerWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final children = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weeklyViewTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: children.isEmpty
          ? Center(child: Text(l10n.noChildren))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: children.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  ChildWeekCard(child: children[index]),
            ),
    );
  }
}

class ChildWeekCard extends ConsumerWidget {
  final Child child;

  const ChildWeekCard({super.key, required this.child});

  List<DateTime> _weekDays() {
    final now = DateTime.now();
    final monday =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return List.generate(5, (i) => monday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekDays = _weekDays();
    final weeklyStar = ref.watch(weeklyStarProvider(child.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            AnimalAvatar(avatarKey: child.avatarKey, name: child.name, size: 56),
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDays
                    .map((day) => DayBadge(childId: child.id, day: day))
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            AnimatedStar(filled: weeklyStar, size: 72),
          ],
        ),
      ),
    );
  }
}

class DayBadge extends ConsumerWidget {
  final String childId;
  final DateTime day;

  const DayBadge({super.key, required this.childId, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dayDate = DateTime(day.year, day.month, day.day);
    final dateKey = _dateFmt.format(day);

    final isComplete = ref.watch(
        isChildCompleteProvider((childId: childId, date: dateKey)));
    final isPast = dayDate.isBefore(todayDate);
    final isToday = dayDate == todayDate;
    final isFuture = dayDate.isAfter(todayDate);

    final dayNames = [
      l10n.weekDay_1, l10n.weekDay_2, l10n.weekDay_3,
      l10n.weekDay_4, l10n.weekDay_5,
    ];
    final dayName = dayNames[day.weekday - 1];

    Color bgColor;
    Color fgColor;
    IconData? icon;

    if (isComplete) {
      bgColor = const Color(0xFF4CAF50);
      fgColor = Colors.white;
      icon = Icons.check;
    } else if (isFuture) {
      bgColor = Colors.grey.shade100;
      fgColor = Colors.grey.shade400;
      icon = null;
    } else {
      // past or today incomplete
      bgColor = isToday ? Colors.orange.shade100 : Colors.grey.shade200;
      fgColor = isToday ? Colors.orange.shade700 : Colors.grey.shade500;
      icon = isPast && !isComplete ? Icons.close : null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dayName,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: fgColor, size: 22)
                : Text(
                    '${day.day}',
                    style: TextStyle(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
          ),
        ),
        if (!isComplete && !isFuture)
          Text(
            '${day.day}',
            style: TextStyle(
                color: fgColor,
                fontSize: 11),
          ),
      ],
    );
  }
}
