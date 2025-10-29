import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/exchange_service.dart';

class ExchangeHistoryScreen extends StatelessWidget {
  final String userId;
  const ExchangeHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Exchange History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ExchangeService.getExchangeHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No transactions found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final data = transactions[index].data() as Map<String, dynamic>;
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final type = data['type'];

              return Card(
                color: const Color(0xFF1D1E33),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    type == 'send'
                        ? 'Sent \$${data['amount']} to ${data['recipient']}'
                        : '${data['amount']} ${data['from']} → ${data['received']} ${data['to']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    type == 'send'
                        ? '${timestamp.toLocal()}'
                        : 'Rate: ${data['rate']} | ${timestamp.toLocal()}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
