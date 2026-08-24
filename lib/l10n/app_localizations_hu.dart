// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Reggeli Rutin';

  @override
  String get navWeekly => 'Heti áttekintés';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get dailyViewTitle => 'Ma';

  @override
  String get weeklyViewTitle => 'Heti áttekintés';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get tabChildren => 'Gyerekek';

  @override
  String get tabActivities => 'Feladatok';

  @override
  String get addChild => 'Gyerek hozzáadása';

  @override
  String get childName => 'Gyerek neve';

  @override
  String get maxChildrenReached => 'Maximum 5 gyerek adható hozzá';

  @override
  String get addActivity => 'Feladat hozzáadása';

  @override
  String get activityLabel => 'Feladat neve';

  @override
  String get activity_toilet => 'WC-re menetel';

  @override
  String get activity_dressing => 'Felöltözés';

  @override
  String get activity_breakfast => 'Reggeli evés';

  @override
  String get activity_teeth => 'Fogmosás';

  @override
  String get activity_bag => 'Táska ellenőrzése';

  @override
  String get weekDay_1 => 'H';

  @override
  String get weekDay_2 => 'K';

  @override
  String get weekDay_3 => 'Sze';

  @override
  String get weekDay_4 => 'Cs';

  @override
  String get weekDay_5 => 'P';

  @override
  String get languageLabel => 'Nyelv';

  @override
  String get deleteConfirm => 'Törlés?';

  @override
  String get cancel => 'Mégse';

  @override
  String get confirm => 'Megerősít';

  @override
  String get noChildren =>
      'Még nincs gyerek. Adj hozzá egyet a beállításokban.';

  @override
  String get noActivities => 'Nincsenek feladatok beállítva.';

  @override
  String deleteChildConfirm(String name) {
    return 'Eltávolítja: $name?';
  }

  @override
  String get deleteActivityConfirm => 'Eltávolítja ezt a feladatot?';

  @override
  String get weeklyStarHint =>
      'Teljesítsd az összes 5 hétköznapet a heti csillagért!';

  @override
  String get settingsLanguageHu => 'Magyar';

  @override
  String get settingsLanguageEn => 'English';
}
