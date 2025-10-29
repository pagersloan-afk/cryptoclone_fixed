import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TradeChartWidget extends StatelessWidget {
  const TradeChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Trade Chart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Transactions')
                  .where('type', isEqualTo: 'deposit') // ✅ Filter for deposits
                  .orderBy('timestamp')
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No trade data',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                final spots = <FlSpot>[];
                final labels = <double, String>{};

                // Normalize timestamps to start from zero
                final baseTimestamp =
                    (docs.first.data() as Map<String, dynamic>)['timestamp']
                        as Timestamp;
                final baseMillis = baseTimestamp
                    .toDate()
                    .millisecondsSinceEpoch
                    .toDouble();

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final amount =
                      double.tryParse(data['amount'].toString()) ?? 0.0;
                  final timestamp = (data['timestamp'] as Timestamp).toDate();
                  final x =
                      timestamp.millisecondsSinceEpoch.toDouble() - baseMillis;
                  spots.add(FlSpot(x, amount));
                  labels[x] = DateFormat.Hm().format(timestamp); // e.g. "11:17"
                }

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final label = labels[value] ?? '';
                            return Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.greenAccent,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.greenAccent.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
