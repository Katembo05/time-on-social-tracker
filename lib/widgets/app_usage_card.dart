import 'package:flutter/material.dart';
import '../models/app_usage_model.dart';
import 'social_media_icon.dart';

class AppUsageCard extends StatelessWidget {
  final AppUsageModel usage;
  final VoidCallback? onTap;

  const AppUsageCard({
    Key? key,
    required this.usage,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SocialMediaIcon(
                    appName: usage.appName,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      usage.appName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '${usage.hoursUsed.toStringAsFixed(1)}h',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: usage.percentageOfLimit,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  usage.percentageOfLimit > 0.9
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Daily limit: ${usage.dailyLimit.toStringAsFixed(1)}h',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 