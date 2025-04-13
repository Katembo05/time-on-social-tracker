class AppUsageInfo {
  final String appName;
  final String packageName;
  final Duration usage;
  final DateTime startTime;
  final DateTime endTime;
  final String? appIcon;

  AppUsageInfo({
    required this.appName,
    required this.packageName,
    required this.usage,
    required this.startTime,
    required this.endTime,
    this.appIcon,
  });

  // Add a method to create from JSON
  factory AppUsageInfo.fromJson(Map<String, dynamic> json) {
    return AppUsageInfo(
      appName: json['appName'] as String,
      packageName: json['packageName'] as String,
      usage: Duration(milliseconds: json['usage'] as int),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      appIcon: json['appIcon'] as String?,
    );
  }

  // Add a method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'usage': usage.inMilliseconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'appIcon': appIcon,
    };
  }
} 