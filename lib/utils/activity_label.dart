import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../l10n/app_localizations.dart';

const Map<String, IconData> activityIconOptions = {
  // Hygiene & morning
  'wc':                  Icons.wc,
  'sanitizer':           Icons.sanitizer,
  'clean_hands':         Icons.clean_hands,
  'wash':                Icons.wash,
  'brush':               Icons.brush,
  'bathtub':             Icons.bathtub,
  'soap':                Icons.soap,
  // Clothing & dressing
  'checkroom':           Icons.checkroom,
  'dry_cleaning':        Icons.dry_cleaning,
  'laundry':             Icons.local_laundry_service,
  // Food & drink
  'free_breakfast':      Icons.free_breakfast,
  'restaurant':          Icons.restaurant,
  'lunch_dining':        Icons.lunch_dining,
  'cake':                Icons.cake,
  'emoji_food_beverage': Icons.emoji_food_beverage,
  'local_pizza':         Icons.local_pizza,
  'icecream':            Icons.icecream,
  // School & learning
  'backpack':            Icons.backpack,
  'book':                Icons.book,
  'school':              Icons.school,
  'edit':                Icons.edit,
  'calculate':           Icons.calculate,
  'science':             Icons.science,
  'palette':             Icons.palette,
  // Physical activity & play
  'directions_run':      Icons.directions_run,
  'directions_bike':     Icons.directions_bike,
  'sports_soccer':       Icons.sports_soccer,
  'sports_basketball':   Icons.sports_basketball,
  'pool':                Icons.pool,
  'hiking':              Icons.hiking,
  'skateboarding':       Icons.skateboarding,
  'self_improvement':    Icons.self_improvement,
  // Home & chores
  'bed':                 Icons.bed,
  'bedroom_baby':        Icons.bedroom_baby,
  'cleaning_services':   Icons.cleaning_services,
  'pets':                Icons.pets,
  'yard':                Icons.yard,
  // Leisure
  'music_note':          Icons.music_note,
  'headphones':          Icons.headphones,
  'videogame_asset':     Icons.videogame_asset,
  'movie':               Icons.movie,
  'star':                Icons.star,
  // General
  'task_alt':            Icons.task_alt,
  'favorite':            Icons.favorite,
  'emoji_events':        Icons.emoji_events,
  'alarm':               Icons.alarm,
  'directions_bus':      Icons.directions_bus,
};

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
  if (activity.isCustom) {
    final key = activity.iconKey;
    if (key != null && activityIconOptions.containsKey(key)) {
      return activityIconOptions[key]!;
    }
    return Icons.task_alt;
  }
  return switch (activity.labelKey) {
    'activity_toilet'    => Icons.wc,
    'activity_dressing'  => Icons.checkroom,
    'activity_breakfast' => Icons.free_breakfast,
    'activity_teeth'     => Icons.clean_hands,
    'activity_bag'       => Icons.backpack,
    _                    => Icons.task_alt,
  };
}
