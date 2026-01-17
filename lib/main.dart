import 'package:flutter/material.dart';

import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home_screen.dart';
import 'screens/health_log_screen.dart';
import 'screens/burnout_insight_screen.dart';
import 'screens/period_tracker.dart';
import 'screens/sakhi_chatbot_screen.dart';
import 'screens/care_circle_screen.dart';
import 'package:sakhi_care/database/db_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await testSqflite();
  runApp(const SakhiCareApp());
}

class SakhiCareApp extends StatelessWidget {
  const SakhiCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SakhiCare',
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(),

      ///ROUTES
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/health-log': (_) => const HealthLogScreen(),
        '/period': (_) => const PeriodTrackerScreen(),
        '/sakhi': (_) => const SakhiChatbotScreen(),
        '/care-circle': (_) => const CareCircleScreen(),
      },
    );
  }
}
