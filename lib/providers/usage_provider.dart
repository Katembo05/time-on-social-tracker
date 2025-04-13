import 'package:flutter/material.dart';
import 'dart:async';
import '../models/app_usage_model.dart';
import '../services/usage_service.dart';

class UsageProvider with ChangeNotifier {
  final UsageService _usageService = UsageService();
  List<AppUsageInfo> _appUsageList = [];
  Map<String, List<AppUsageInfo>> _weeklyUsage = {};
  Duration _totalUsageToday = Duration.zero;
  bool _isBlocked = false;
  DateTime? _blockEndTime;

  // Getters
  List<AppUsageInfo> get appUsageList => _appUsageList;
  Duration get totalUsageToday => _totalUsageToday;
  bool get isBlocked => _isBlocked;
  DateTime? get blockEndTime => _blockEndTime;
  Map<String, List<AppUsageInfo>> get weeklyUsage => _weeklyUsage;

  // Start tracking app usage
  void startTracking() async {
    // Check if already blocked
    final blocked = await _usageService.checkIfBlocked();
    if (blocked) {
      _isBlocked = true;
      _blockEndTime = await _usageService.getBlockEndTime();
      notifyListeners();
    }
    
    // Initial update
    updateUsageStats();
    
    // Update historical data
    updateWeeklyUsage();
  }

  // Update current usage stats
  void updateUsageStats() async {
    final DateTime endDate = DateTime.now();
    final DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);
    
    try {
      _appUsageList = await _usageService.getAppUsage(startDate, endDate);
      _calculateTotalUsage();
      notifyListeners();
      
      // Check if limit reached
      if (_totalUsageToday.inMinutes >= 40 && !_isBlocked) {
        blockApps();
      }
    } catch (e) {
      debugPrint('Error getting app usage: $e');
    }
  }

  // Update weekly usage history
  void updateWeeklyUsage() async {
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(const Duration(days: 7));
    
    try {
      _weeklyUsage = await _usageService.getWeeklyUsage(startDate, endDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting weekly usage: $e');
    }
  }

  // Block apps when limit is reached
  void blockApps() async {
    _isBlocked = true;
    _blockEndTime = DateTime.now().add(const Duration(hours: 24));
    await _usageService.blockSocialApps(_blockEndTime!);
    notifyListeners();
  }

  // Calculate total usage from all tracked apps
  void _calculateTotalUsage() {
    Duration total = Duration.zero;
    for (var app in _appUsageList) {
      total += app.usage;
    }
    _totalUsageToday = total;
  }
} 