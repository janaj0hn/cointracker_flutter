import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CoinChart extends StatelessWidget {
  final List<List<dynamic>> prices;
  final bool isLoading;
  final bool hasError;

  const CoinChart({
    super.key,
    required this.prices,
    required this.isLoading,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    // Loading
    if (isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Error
    if (hasError) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('Unable to load chart')),
      );
    }

    // Empty
    if (prices.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('No chart data available')),
      );
    }

    // API data → chart points
    List<FlSpot> chartPoints = [];

    for (int i = 0; i < prices.length; i++) {
      double price = prices[i][1].toDouble();

      chartPoints.add(FlSpot(i.toDouble(), price));
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
            },
          ),

          borderData: FlBorderData(show: false),

          // Y-axis
          minY:
              chartPoints.map((e) => e.y).reduce((a, b) => a < b ? a : b) *
              0.95,

          maxY:
              chartPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) *
              1.05,

          titlesData: FlTitlesData(
            // LEFT SIDE - Price
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,

                getTitlesWidget: (value, meta) {
                  return Text(
                    formatNumber(value),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  );
                },
              ),
            ),

            // BOTTOM
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,

                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 2 == 0) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          lineTouchData: LineTouchData(
            enabled: true,

            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${formatNumber(spot.y)}',
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: chartPoints,

              isCurved: true,

              barWidth: 3,

              dotData: const FlDotData(show: false),

              // Area below chart
              belowBarData: BarAreaData(
                show: true,

                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.withOpacity(0.35),
                    Colors.blue.withOpacity(0.05),
                  ],
                ),
              ),

              // Line gradient
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.green],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(double number) {
  if (number >= 1000000000000) {
    return '${(number / 1000000000000).toStringAsFixed(2)}T';
  }

  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(2)}B';
  }

  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(2)}M';
  }

  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(2)}K';
  }

  return number.toStringAsFixed(2);
}
