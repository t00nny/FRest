import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/core/navigation_container.dart';
import 'package:quit_companion/src/core/theme.dart';
import 'package:quit_companion/src/data/repositories/settings_repository.dart';
import 'package:quit_companion/src/features/onboarding/onboarding_screen.dart';

class QuitCompanionApp extends StatelessWidget {
  const QuitCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quit Companion',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _isOnboardingComplete;

  @override
  void initState() {
    super.initState();
    _isOnboardingComplete = context
        .read<SettingsRepository>()
        .isOnboardingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOnboardingComplete,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const NavigationContainer();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
