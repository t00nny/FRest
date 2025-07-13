import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/app.dart';
import 'package:quit_companion/src/data/database_helper.dart';
import 'package:quit_companion/src/data/repositories/goal_repository.dart';
import 'package:quit_companion/src/data/repositories/journal_repository.dart';
import 'package:quit_companion/src/data/repositories/resource_repository.dart';
import 'package:quit_companion/src/data/repositories/settings_repository.dart';
import 'package:quit_companion/src/data/repositories/stats_repository.dart';
import 'package:quit_companion/src/features/goals/goals_provider.dart';
import 'package:quit_companion/src/features/home/home_provider.dart';
import 'package:quit_companion/src/features/journal/journal_provider.dart';
import 'package:quit_companion/src/features/journey/journey_provider.dart';
import 'package:quit_companion/src/features/manage_resources/manage_resources_provider.dart';
import 'package:quit_companion/src/features/toolkit/toolkit_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Get instances of singletons
  final dbHelper = DatabaseHelper.instance;
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // Provide singleton instances
        Provider<DatabaseHelper>.value(value: dbHelper),
        Provider<SharedPreferences>.value(value: prefs),

        // Provide repositories that depend on the database
        Provider<SettingsRepository>(
          create: (_) => SettingsRepository(dbHelper: dbHelper, prefs: prefs),
        ),
        Provider<StatsRepository>(
          create: (_) => StatsRepository(dbHelper: dbHelper),
        ),
        Provider<JournalRepository>(
          create: (_) => JournalRepository(dbHelper: dbHelper),
        ),
        Provider<GoalRepository>(
          create: (_) => GoalRepository(dbHelper: dbHelper),
        ),
        Provider<ResourceRepository>(
          create: (_) => ResourceRepository(dbHelper: dbHelper),
        ),

        // Provide ChangeNotifiers (Providers) that depend on repositories
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            settingsRepository: context.read<SettingsRepository>(),
            statsRepository: context.read<StatsRepository>(),
          ),
        ),
        ChangeNotifierProvider<JournalProvider>(
          create: (context) =>
              JournalProvider(context.read<JournalRepository>()),
        ),
        ChangeNotifierProvider<GoalsProvider>(
          create: (context) => GoalsProvider(context.read<GoalRepository>()),
        ),
        ChangeNotifierProvider<ToolkitProvider>(
          create: (context) =>
              ToolkitProvider(context.read<ResourceRepository>()),
        ),
        ChangeNotifierProvider<JourneyProvider>(
          create: (context) => JourneyProvider(context.read<StatsRepository>()),
        ),
        ChangeNotifierProvider<ManageResourcesProvider>(
          create: (context) =>
              ManageResourcesProvider(context.read<ResourceRepository>()),
        ),
      ],
      child: const QuitCompanionApp(),
    ),
  );
}
