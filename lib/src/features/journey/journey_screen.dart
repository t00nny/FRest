// lib/src/features/journey/journey_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/features/journey/journey_provider.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JourneyProvider>().fetchData();
    });
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
        title: const Text('My Journey'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.insights), text: 'Insights'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Calendar'),
          ],
        ),
      ),
      body: Consumer<JourneyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.checkins.isEmpty) {
            return Center(
              child: Text(
                'No data yet. Complete a daily check-in to see your journey.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildInsightsView(provider),
              _buildCalendarView(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInsightsView(JourneyProvider provider) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Score Trend (Last 30 Days)', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: provider.checkins
                      .take(30)
                      .map((c) {
                        return FlSpot(
                          c.date.millisecondsSinceEpoch.toDouble(),
                          c.score.toDouble(),
                        );
                      })
                      .toList()
                      .reversed
                      .toList(),
                  isCurved: true,
                  color: theme.colorScheme.primary,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.3),
                        theme.colorScheme.primary.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView(JourneyProvider provider) {
    final heatmapData = provider.calendarHeatmapData;
    final today = DateTime.now();
    final firstDay = DateTime(today.year, today.month, 1);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: [
          TableRow(
            children: List.generate(
              7,
              (index) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    DateFormat.E().format(
                      firstDay.add(
                        Duration(days: index - firstDay.weekday + 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(6, (weekIndex) {
            return TableRow(
              children: List.generate(7, (dayIndex) {
                final dayOffset =
                    (weekIndex * 7) + dayIndex - firstDay.weekday + 1;
                final currentDate = firstDay.add(Duration(days: dayOffset));

                if (currentDate.month != firstDay.month) {
                  return const SizedBox();
                }

                final score = heatmapData[currentDate];
                Color color = Theme.of(context).colorScheme.surface;
                if (score != null) {
                  if (score > 75)
                    color = Colors.green.withOpacity(0.7);
                  else if (score > 40)
                    color = Colors.yellow.withOpacity(0.7);
                  else
                    color = Colors.red.withOpacity(0.7);
                }

                return AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(child: Text(currentDate.day.toString())),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
