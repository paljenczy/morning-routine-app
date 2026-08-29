// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Morning Routine';

  @override
  String get navWeekly => 'Weekly';

  @override
  String get navSettings => 'Settings';

  @override
  String get dailyViewTitle => 'Today';

  @override
  String get weeklyViewTitle => 'Weekly Overview';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get tabChildren => 'Children';

  @override
  String get tabActivities => 'Activities';

  @override
  String get tabGeneral => 'General';

  @override
  String get addChild => 'Add Child';

  @override
  String get childName => 'Child\'s name';

  @override
  String get maxChildrenReached => 'Maximum 5 children';

  @override
  String get addActivity => 'Add Activity';

  @override
  String get activityLabel => 'Activity name';

  @override
  String get selectIcon => 'Choose icon';

  @override
  String get activity_toilet => 'Going to the toilet';

  @override
  String get activity_dressing => 'Dressing up';

  @override
  String get activity_breakfast => 'Eating breakfast';

  @override
  String get activity_teeth => 'Wash teeth';

  @override
  String get activity_bag => 'Check bag';

  @override
  String get weekDay_1 => 'Mon';

  @override
  String get weekDay_2 => 'Tue';

  @override
  String get weekDay_3 => 'Wed';

  @override
  String get weekDay_4 => 'Thu';

  @override
  String get weekDay_5 => 'Fri';

  @override
  String get weekDay_6 => 'Sat';

  @override
  String get weekDay_7 => 'Sun';

  @override
  String get languageLabel => 'Language';

  @override
  String get deleteConfirm => 'Delete?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get noChildren => 'No children yet. Add one in Settings.';

  @override
  String get noActivities => 'No activities configured.';

  @override
  String deleteChildConfirm(String name) {
    return 'Remove $name?';
  }

  @override
  String get deleteActivityConfirm => 'Remove this activity?';

  @override
  String get editAvatar => 'Change Avatar';

  @override
  String get weeklyStarHint => 'Complete all 7 days to earn the super star!';

  @override
  String get settingsLanguageHu => 'Magyar';

  @override
  String get settingsLanguageEn => 'English';
}
