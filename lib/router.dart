import 'package:go_router/go_router.dart';
import 'screens/daily_view/daily_screen.dart';
import 'screens/weekly_overview/weekly_screen.dart';
import 'screens/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DailyScreen(),
    ),
    GoRoute(
      path: '/weekly',
      builder: (context, state) => const WeeklyScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
