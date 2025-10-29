import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnifiedActivityScreen extends StatefulWidget {
  final String userId;
  const UnifiedActivityScreen({super.key, required this.userId});

  @override
  State<UnifiedActivityScreen> createState() => _UnifiedActivityScreenState();
}

class _UnifiedActivityScreenState extends State<UnifiedActivityScreen> {
  late Future<List<Map<String, dynamic>>> _allActivity;
  late Stream<QuerySnapshot> _exchangeStream;
  late Stream<QuerySnapshot> _transactionStream;

  final NumberFormat _usdFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _allActivity = ExchangeService.getUnifiedActivity(widget.userId);
    _exchangeStream = ExchangeService.getExchangeHistory(widget.userId);
    _transactionStream = ExchangeService.getTransactionHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0E1C),
        appBar: AppBar(
          title: const Text('Activity Feed'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Swaps & Deposits'),
              Tab(text: 'Transfers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllTab(),
            _buildStreamTab(_exchangeStream, 'exchange'),
            _buildStreamTab(_transactionStream, 'transaction'),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _allActivity,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final activities = snapshot.data!;
        if (activities.isEmpty) {
          return const Center(
            child: Text(
              'No activity found',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final data = activities[index];
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final source = data['source'];
            final amount = _usdFormat.format(data['amount']);

            String title;
            if (source == 'exchange') {
              title =
                  '$amount ${data['from']} → ${data['received']} ${data['to']}';
            } else {
              final type = data['type'];
              if (type == 'send') {
                title = 'Sent $amount to ${data['recipient']}';
              } else if (type == 'deposit') {
                title = 'Deposited $amount';
              } else {
                title = 'Unknown transaction';
              }
            }

            return _buildCard(title, source, timestamp);
          },
        );
      },
    );
  }

  Widget _buildStreamTab(Stream<QuerySnapshot> stream, String source) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No activity found',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final amount = _usdFormat.format(data['amount']);

            String title;
            if (source == 'exchange') {
              title =
                  '$amount ${data['from']} → ${data['received']} ${data['to']}';
            } else {
              final type = data['type'];
              if (type == 'send') {
                title = 'Sent $amount to ${data['recipient']}';
              } else if (type == 'deposit') {
                title = 'Deposited $amount';
              } else {
                title = 'Unknown transaction';
              }
            }

            return _buildCard(title, source, timestamp);
          },
        );
      },
    );
  }

  Widget _buildCard(String title, String source, DateTime timestamp) {
    return Card(
      color: const Color(0xFF1D1E33),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          '${source.toUpperCase()} | ${timestamp.toLocal()}',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
