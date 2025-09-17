import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/config/firebase_config.dart';
import 'core/services/firebase_messaging_service.dart';
import 'features/auth/presentation/providers/firebase_auth_provider.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'features/home/presentation/providers/challenges_provider.dart';
import 'features/betting/presentation/providers/betting_provider.dart';
import 'features/teams/presentation/providers/teams_provider.dart';
import 'features/leaderboard/presentation/providers/leaderboard_provider.dart';
import 'features/live_streams/presentation/providers/live_streams_provider.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await FirebaseConfig.initialize();

    // Initialize Firebase Messaging
    await FirebaseMessagingService.initialize();
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('Running in development mode without Firebase');
  }

  await configureDependencies();

  // Initialize notifications
  await NotificationService().initialize();

  runApp(const SalesBetsApp());
}

class SalesBetsApp extends StatelessWidget {
  const SalesBetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (context) => ChallengesProvider()),
        ChangeNotifierProvider(create: (context) => BettingProvider()),
        ChangeNotifierProvider(create: (context) => TeamsProvider()),
        ChangeNotifierProvider(create: (context) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (context) => LiveStreamsProvider()),
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sales Bets',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/main': (context) => const MainPage(),
            },
          );
        },
      ),
    );
  }
}
