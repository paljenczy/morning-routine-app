import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../l10n/app_localizations.dart';

String resolveActivityLabel(Activity activity, AppLocalizations l10n) {
  if (activity.isCustom) return activity.labelKey;
  return switch (activity.labelKey) {
    'activity_toilet'    => l10n.activity_toilet,
    'activity_dressing'  => l10n.activity_dressing,
    'activity_breakfast' => l10n.activity_breakfast,
    'activity_teeth'     => l10n.activity_teeth,
    'activity_bag'       => l10n.activity_bag,
    _                    => activity.labelKey,
  };
}

IconData resolveActivityIcon(Activity activity) {
  if (activity.isCustom) return Icons.check_box_outline_blank;
  return switch (activity.labelKey) {
    'activity_toilet'    => Icons.wc,
    'activity_dressing'  => Icons.checkroom,
    'activity_breakfast' => Icons.free_breakfast,
    'activity_teeth'     => Icons.sanitizer,
    'activity_bag'       => Icons.backpack,
    _                    => Icons.task_alt,
  };
}
