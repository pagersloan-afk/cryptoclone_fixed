import 'package:ecommerce_app/models/trade_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shimmer/shimmer.dart'; // ✅ Add this import

class CandlestickChart extends StatelessWidget {
  final List<TradeData> data;
  final String asset;
  final String selectedCoin;
  final int selectedDays;
  final Function(String) onCoinChange;
  final Function(int) onDaysChange;

  const CandlestickChart({
    super.key,
    required this.data,
    required this.asset,
    required this.selectedCoin,
    required this.selectedDays,
    required this.onCoinChange,
    required this.onDaysChange,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Asset Label
          Text(
            '📊 ${asset.toUpperCase()} Chart',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Coin Selector
          DropdownButton<String>(
            value: selectedCoin,
            dropdownColor: Colors.black,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            items: ['bitcoin', 'ethereum', 'binancecoin'].map((coin) {
              return DropdownMenuItem(
                value: coin,
                child: Text(coin.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onCoinChange(value);
            },
          ),

          // 🔹 Timeframe Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 7, 30].map((day) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDays == day
                        ? Colors.green
                        : Colors.grey.shade700,
                  ),
                  onPressed: () => onDaysChange(day),
                  child: Text('${day}D'),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // 🔹 Candlestick Chart or Shimmer
          data.isEmpty
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade600,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SfCartesianChart(
                      backgroundColor: Colors.transparent,
                      plotAreaBorderWidth: 0,
                      tooltipBehavior: TooltipBehavior(enable: true),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        zoomMode: ZoomMode.x,
                      ),
                      primaryXAxis: DateTimeAxis(
                        intervalType: DateTimeIntervalType.auto,
                        dateFormat: selectedDays == 1
                            ? DateFormat.Hm()
                            : DateFormat.Md(),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        opposedPosition: true,
                        majorGridLines: const MajorGridLines(width: 0),
                        axisLine: const AxisLine(width: 0),
                      ),
                      series: <CandleSeries>[
                        CandleSeries<TradeData, DateTime>(
                          dataSource: data,
                          xValueMapper: (d, _) => d.time,
                          lowValueMapper: (d, _) => d.low,
                          highValueMapper: (d, _) => d.high,
                          openValueMapper: (d, _) => d.open,
                          closeValueMapper: (d, _) => d.close,
                          enableTooltip: true,
                          bearColor: Colors.red,
                          bullColor: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Volume Bar Chart
                    SizedBox(
                      height: 80,
                      child: SfCartesianChart(
                        backgroundColor: Colors.transparent,
                        plotAreaBorderWidth: 0,
                        primaryXAxis: DateTimeAxis(isVisible: false),
                        primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(width: 0),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        series: <ColumnSeries>[
                          ColumnSeries<TradeData, DateTime>(
                            dataSource: data,
                            xValueMapper: (d, _) => d.time,
                            yValueMapper: (d, _) => d.volume,
                            pointColorMapper: (d, _) => d.close >= d.open
                                ? Colors.green.withOpacity(0.6)
                                : Colors.red.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
