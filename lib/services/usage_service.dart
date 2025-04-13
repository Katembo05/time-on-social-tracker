import 'dart:async';
import 'dart:math';
import '../models/app_usage_model.dart';

class UsageService {
  final List<String> _socialApps = [
    'Facebook',
    'Instagram',
    'Twitter',
    'TikTok',
    'Snapchat',
  ];

  final Map<String, String> _packageNames = {
    'Facebook': 'com.facebook.katana',
    'Instagram': 'com.instagram.android',
    'Twitter': 'com.twitter.android',
    'TikTok': 'com.zhiliaoapp.musically',
    'Snapchat': 'com.snapchat.android',
  };

  // Get app usage for a specific time period
  Future<List<AppUsageInfo>> getAppUsage(DateTime startDate, DateTime endDate) async {
    // In a real app, you would use platform channels to access Android's UsageStatsManager
    // or iOS's Screen Time API. For this example, we'll generate mock data.
    
    // Use a predictable random for consistent mockups
    final random = Random(DateTime.now().day);
    
    List<AppUsageInfo> usageList = [];
    
    for (String app in _socialApps) {
      // Generate random usage between 5-20 minutes
      final int minutes = random.nextInt(15) + 5;
      final usage = Duration(minutes: minutes);
      
      usageList.add(
        AppUsageInfo(
          appName: app,
          packageName: _packageNames[app] ?? 'unknown',
          usage: usage,
          startTime: startDate,
          endTime: endDate,
        ),
      );
    }
    
    // Sort by usage (highest first)
    usageList.sort((a, b) => b.usage.compareTo(a.usage));
    
    return usageList;
  }

  // Get weekly usage data
  Future<Map<String, List<AppUsageInfo>>> getWeeklyUsage(
    DateTime startDate, 
    DateTime endDate
  ) async {
    Map<String, List<AppUsageInfo>> weeklyData = {};
    
    // Generate usage data for each day in the past week
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month}-${date.day}';
      
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
      
      weeklyData[dateStr] = await getAppUsage(dayStart, dayEnd);
    }
    
    return weeklyData;
  }

  // Check if social apps are currently blocked
  Future<bool> checkIfBlocked() async {
    // In a real app, this would check if blocking is active
    // For this example, we'll return false
    return false;
  }

  // Get the time when the block will end
  Future<DateTime> getBlockEndTime() async {
    // In a real app, this would return the actual end time
    // For this example, we'll return a time 24 hours from now
    return DateTime.now().add(Duration(hours: 24));
  }

  // Block social apps
  Future<void> blockSocialApps(DateTime endTime) async {
    // In a real app, this would use platform-specific code to block apps
    // For Android, this might involve:
    // - Using UsageStatsManager to track usage
    // - Using accessibility services to detect app launches
    // - Using overlay windows to block app access
    
    print('Blocking social apps until: $endTime');
    // Implementation would depend on platform capabilities
  }
} 