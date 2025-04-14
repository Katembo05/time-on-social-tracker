import 'package:flutter/material.dart';
import '../models/app_usage_model.dart';
import '../widgets/app_usage_card.dart';
import '../widgets/usage_circle.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Sample data for testing
  static const List<AppUsageModel> sampleData = [
    AppUsageModel(
      appName: 'Instagram',
      hoursUsed: 2.5,
      dailyLimit: 3.0,
    ),
    AppUsageModel(
      appName: 'TikTok',
      hoursUsed: 1.8,
      dailyLimit: 2.0,
    ),
    AppUsageModel(
      appName: 'Facebook',
      hoursUsed: 1.2,
      dailyLimit: 2.0,
    ),
    AppUsageModel(
      appName: 'Twitter',
      hoursUsed: 0.8,
      dailyLimit: 1.5,
    ),
    AppUsageModel(
      appName: 'WhatsApp',
      hoursUsed: 1.5,
      dailyLimit: 3.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double totalHours = sampleData.fold(0, (sum, item) => sum + item.hoursUsed);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Wellbeing'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Today\'s Usage',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // Usage Circle with icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UsageCircle(
                usageData: sampleData,
                totalHours: totalHours,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'App Usage',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            // App Usage Cards with icons
            ...sampleData.map((usage) => AppUsageCard(
              usage: usage,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped on ${usage.appName}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            )).toList(),
          ],
        ),
      ),
    );
  }
} 