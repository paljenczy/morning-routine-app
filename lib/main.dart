import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'models/child.dart';
import 'models/activity.dart';
import 'models/completion_record.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(ChildAdapter());
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(CompletionRecordAdapter());
  await Hive.openBox<Child>('children');
  await Hive.openBox<Activity>('activities');
  await Hive.openBox<CompletionRecord>('completions');

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => SettingsNotifier(prefs),
        ),
      ],
      child: const App(),
    ),
  );
}
