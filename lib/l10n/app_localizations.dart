import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Routine'**
  String get appTitle;

  /// No description provided for @navWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get navWeekly;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @dailyViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dailyViewTitle;

  /// No description provided for @weeklyViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Overview'**
  String get weeklyViewTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @tabChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get tabChildren;

  /// No description provided for @tabActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get tabActivities;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s name'**
  String get childName;

  /// No description provided for @maxChildrenReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 children'**
  String get maxChildrenReached;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivity;

  /// No description provided for @activityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity name'**
  String get activityLabel;

  /// No description provided for @activity_toilet.
  ///
  /// In en, this message translates to:
  /// **'Going to the toilet'**
  String get activity_toilet;

  /// No description provided for @activity_dressing.
  ///
  /// In en, this message translates to:
  /// **'Dressing up'**
  String get activity_dressing;

  /// No description provided for @activity_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Eating breakfast'**
  String get activity_breakfast;

  /// No description provided for @activity_teeth.
  ///
  /// In en, this message translates to:
  /// **'Wash teeth'**
  String get activity_teeth;

  /// No description provided for @activity_bag.
  ///
  /// In en, this message translates to:
  /// **'Check bag'**
  String get activity_bag;

  /// No description provided for @weekDay_1.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekDay_1;

  /// No description provided for @weekDay_2.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekDay_2;

  /// No description provided for @weekDay_3.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekDay_3;

  /// No description provided for @weekDay_4.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekDay_4;

  /// No description provided for @weekDay_5.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekDay_5;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @noChildren.
  ///
  /// In en, this message translates to:
  /// **'No children yet. Add one in Settings.'**
  String get noChildren;

  /// No description provided for @noActivities.
  ///
  /// In en, this message translates to:
  /// **'No activities configured.'**
  String get noActivities;

  /// No description provided for @deleteChildConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String deleteChildConfirm(String name);

  /// No description provided for @deleteActivityConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this activity?'**
  String get deleteActivityConfirm;

  /// No description provided for @weeklyStarHint.
  ///
  /// In en, this message translates to:
  /// **'Complete all 5 weekdays to earn the weekly star!'**
  String get weeklyStarHint;

  /// No description provided for @settingsLanguageHu.
  ///
  /// In en, this message translates to:
  /// **'Magyar'**
  String get settingsLanguageHu;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
