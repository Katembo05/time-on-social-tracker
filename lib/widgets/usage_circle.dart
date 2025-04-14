import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/app_usage_model.dart';
import 'social_media_icon.dart';

class UsageCircle extends StatelessWidget {
  final List<AppUsageModel> usageData;
  final double totalHours;

  const UsageCircle({
    Key? key,
    required this.usageData,
    required this.totalHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sections: _createSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      totalHours.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'hours today',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: _createLegendItems(context),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createSections() {
    final List<PieChartSectionData> sections = [];
    
    for (var i = 0; i < usageData.length; i++) {
      final usage = usageData[i];
      final percentage = (usage.hoursUsed / totalHours) * 100;
      
      sections.add(
        PieChartSectionData(
          value: percentage,
          title: '',
          radius: 60,
          color: _getColorForIndex(i),
        ),
      );
    }
    
    return sections;
  }

  List<Widget> _createLegendItems(BuildContext context) {
    return usageData.asMap().entries.map((entry) {
      final index = entry.key;
      final usage = entry.value;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SocialMediaIcon(
              appName: usage.appName,
              size: 16,
              color: _getColorForIndex(index),
            ),
            const SizedBox(width: 4),
            Text(
              '${usage.appName}: ${usage.hoursUsed.toStringAsFixed(1)}h',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF4285F4), // Blue
      const Color(0xFF34A853), // Green
      const Color(0xFFFBBC05), // Yellow
      const Color(0xFFEA4335), // Red
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
    ];
    return colors[index % colors.length];
  }
} 