import 'package:flutter/material.dart';

class AppUsageCard extends StatelessWidget {
  final String appName;
  final Duration usage;
  final int index;
  
  const AppUsageCard({
    Key? key,
    required this.appName,
    required this.usage,
    required this.index,
  }) : super(key: key);

  Color _getColorForIndex(BuildContext context, int index) {
    final colors = [
      Theme.of(context).primaryColor,
      Theme.of(context).colorScheme.secondary,
      const Color(0xFFFBBC05), // Warning color
      const Color(0xFFEA4335), // Error color
      Colors.purple,
    ];
    
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final minutes = usage.inMinutes;
    final seconds = usage.inSeconds % 60;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // App icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getColorForIndex(context, index).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  appName.substring(0, 1),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _getColorForIndex(context, index),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // App details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Today\'s usage',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            // Usage time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$minutes min',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getColorForIndex(context, index),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (seconds > 0)
                  Text(
                    '$seconds sec',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 