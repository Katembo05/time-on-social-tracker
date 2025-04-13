import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/usage_provider.dart';
import '../models/app_usage_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usage History',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DailyUsageTab(),
          WeeklyUsageTab(),
        ],
      ),
    );
  }
}

class DailyUsageTab extends StatelessWidget {
  const DailyUsageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UsageProvider>(
      builder: (context, usageProvider, child) {
        final appUsageList = usageProvider.appUsageList;
        final totalMinutes = usageProvider.totalUsageToday.inMinutes;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Total usage: $totalMinutes minutes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              
              // Pie chart
              if (appUsageList.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieSections(context, appUsageList),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              Text(
                'App Breakdown',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // App usage list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appUsageList.length,
                itemBuilder: (context, index) {
                  final app = appUsageList[index];
                  final percentage = (app.usage.inMinutes / totalMinutes * 100).round();
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForIndex(context, index).withOpacity(0.2),
                      child: Text(
                        app.appName[0],
                        style: TextStyle(
                          color: _getColorForIndex(context, index),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(app.appName),
                    subtitle: Text('${app.usage.inMinutes} minutes'),
                    trailing: Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getColorForIndex(context, index),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

  List<PieChartSectionData> _buildPieSections(BuildContext context, List<AppUsageInfo> usageList) {
    final total = usageList.fold<int>(
      0,
      (sum, app) => sum + app.usage.inMinutes,
    );
    
    return usageList.asMap().entries.map((entry) {
      final index = entry.key;
      final app = entry.value;
      final percentage = app.usage.inMinutes / total;
      
      return PieChartSectionData(
        color: _getColorForIndex(context, index),
        value: percentage * 100,
        title: '${(percentage * 100).round()}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

class WeeklyUsageTab extends StatelessWidget {
  const WeeklyUsageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UsageProvider>(
      builder: (context, usageProvider, child) {
        final weeklyData = usageProvider.weeklyUsage;
        
        if (weeklyData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past 7 Days',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Bar chart
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxUsage(weeklyData),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.now().subtract(Duration(days: value.toInt()));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('E').format(date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}m',
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _createBarGroups(context, weeklyData),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 30,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              Text(
                'Weekly Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Weekly stats
              _buildWeeklySummary(context, weeklyData),
            ],
          ),
        );
      },
    );
  }

  double _getMaxUsage(Map<String, List<AppUsageInfo>> weeklyData) {
    double maxUsage = 0;
    for (var dayData in weeklyData.values) {
      final dayTotal = dayData.fold<int>(
        0,
        (sum, app) => sum + app.usage.inMinutes,
      );
      maxUsage = maxUsage < dayTotal ? dayTotal.toDouble() : maxUsage;
    }
    return maxUsage + 30; // Add padding
  }

  List<BarChartGroupData> _createBarGroups(
    BuildContext context,
    Map<String, List<AppUsageInfo>> weeklyData,
  ) {
    final List<BarChartGroupData> groups = [];
    final sortedDates = weeklyData.keys.toList()..sort();
    
    for (var i = 0; i < sortedDates.length; i++) {
      final dayData = weeklyData[sortedDates[i]]!;
      final totalMinutes = dayData.fold<int>(
        0,
        (sum, app) => sum + app.usage.inMinutes,
      );
      
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalMinutes.toDouble(),
              color: Theme.of(context).primaryColor,
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }
    
    return groups;
  }

  Widget _buildWeeklySummary(
    BuildContext context,
    Map<String, List<AppUsageInfo>> weeklyData,
  ) {
    int totalMinutes = 0;
    int daysOverLimit = 0;
    
    for (var dayData in weeklyData.values) {
      final dayTotal = dayData.fold<int>(
        0,
        (sum, app) => sum + app.usage.inMinutes,
      );
      totalMinutes += dayTotal;
      if (dayTotal > 40) daysOverLimit++;
    }
    
    final averageMinutes = totalMinutes ~/ 7;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow(
              context,
              'Average daily usage',
              '$averageMinutes minutes',
              Icons.access_time,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Days over limit',
              '$daysOverLimit days',
              Icons.warning_rounded,
              isWarning: true,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Total weekly usage',
              '$totalMinutes minutes',
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isWarning = false,
  }) {
    final color = isWarning
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).primaryColor;
    
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
} 