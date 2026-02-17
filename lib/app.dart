import 'package:flutter/material.dart';

import 'data/onboarding_repository.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

class PamutemoApp extends StatelessWidget {
  const PamutemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaMutemo',
      theme: buildAppTheme(),
      home: const _AppBootstrap(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _AppBootstrap extends StatelessWidget {
  const _AppBootstrap();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: OnboardingRepository.isCompleted(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final completed = snapshot.data ?? false;
        return completed ? const HomeShell() : const OnboardingScreen();
      },
    );
  }
}
