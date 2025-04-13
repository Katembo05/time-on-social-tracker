import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usage_provider.dart';
import '../widgets/usage_circle.dart';
import '../widgets/app_usage_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UsageProvider>(
      builder: (context, usageProvider, child) {
        final totalMinutes = usageProvider.totalUsageToday.inMinutes;
        final appUsageList = usageProvider.appUsageList;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Digital Wellbeing',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            elevation: 0,
            centerTitle: false,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                usageProvider.updateUsageStats();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Text(
                        'Today\'s Digital Usage',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monitor and manage your social media time',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      
                      // Usage circle
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: UsageCircle(
                            usedMinutes: totalMinutes,
                            totalMinutes: 40, // Daily limit
                          ),
                        ),
                      ),
                      
                      // Apps breakdown title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Apps Breakdown',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      
                      // App usage cards
                      if (appUsageList.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: appUsageList.length,
                          itemBuilder: (context, index) {
                            final app = appUsageList[index];
                            return AppUsageCard(
                              appName: app.appName,
                              usage: app.usage,
                              index: index,
                            );
                          },
                        ),
                        
                      // Tip of the day
                      const SizedBox(height: 24),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tip of the day',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try turning on "Do Not Disturb" mode when you need to focus. This reduces the temptation to check notifications.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 