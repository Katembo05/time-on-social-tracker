import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../providers/usage_provider.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'block_screen.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;
  
  const AppShell({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  late int _currentIndex;
  late Timer _usageUpdateTimer;
  late Timer _notificationTimer;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DashboardScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);
    
    // Start tracking app usage
    Provider.of<UsageProvider>(context, listen: false).startTracking();
    
    // Set timers for usage updates and notifications
    _setupTimers();
    
    // Schedule page controller to jump to initial index after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _setupTimers() {
    // Update usage data every minute
    _usageUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        Provider.of<UsageProvider>(context, listen: false).updateUsageStats();
      }
    });
    
    // Show notification every 5 minutes
    _notificationTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (mounted) {
        _showUsageNotification();
      }
    });
  }

  void _showUsageNotification() async {
    final usage = Provider.of<UsageProvider>(context, listen: false);
    final minutesUsed = usage.totalUsageToday.inMinutes;
    final minutesRemaining = 40 - minutesUsed;
    
    if (minutesUsed >= 0 && minutesUsed < 40) {
      // Show notification
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
          
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'usage_channel',
        'Usage Updates',
        channelDescription: 'Notifications about social media usage',
        importance: Importance.low,
        priority: Priority.low,
        showWhen: false,
      );
      
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
          
      await flutterLocalNotificationsPlugin.show(
        0,
        'Digital Wellbeing',
        'Social media: $minutesUsed/40 minutes used today',
        platformChannelSpecifics,
      );
      
      // Provide haptic feedback
      HapticFeedback.lightImpact();
    } else if (minutesUsed >= 40 && !usage.isBlocked) {
      // Block apps when limit is reached
      usage.blockApps();
      
      // Navigate to block screen
      Navigator.pushNamed(context, '/block');
    }
  }

  @override
  void dispose() {
    _usageUpdateTimer.cancel();
    _notificationTimer.cancel();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Update usage stats when app is resumed
    if (state == AppLifecycleState.resumed) {
      Provider.of<UsageProvider>(context, listen: false).updateUsageStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
} 