import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'providers/usage_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/app_shell.dart';
import 'utils/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  bool isFirstLaunch = await checkFirstLaunch();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsageProvider()),
      ],
      child: DigitalWellbeingApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

Future<bool> checkFirstLaunch() async {
  // In a real app, you would use SharedPreferences to check if this is the first launch
  // For this example, we'll always show the onboarding screen
  return true;
}

class DigitalWellbeingApp extends StatelessWidget {
  final bool isFirstLaunch;
  
  const DigitalWellbeingApp({Key? key, required this.isFirstLaunch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Wellbeing',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,
      home: isFirstLaunch ? OnboardingScreen() : AppShell(),
      routes: {
        '/dashboard': (context) => AppShell(initialIndex: 0),
        '/history': (context) => AppShell(initialIndex: 1),
        '/settings': (context) => AppShell(initialIndex: 2),
        // '/block': (context) => const BlockScreen(),
      },
    );
  }
} 