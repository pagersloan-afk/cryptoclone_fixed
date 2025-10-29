import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screen/activity_screen.dart';
import 'package:flutter/material.dart';
import 'activity_tile.dart';
import 'package:ecommerce_app/models/transaction.dart' as model;

class ActivityWidget extends StatelessWidget {
  final bool showAll;
  const ActivityWidget({super.key, this.showAll = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Transactions')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No activity yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final allTransactions = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return model.Transaction(
            type: data['type'] ?? '',
            label: data['label'] ?? '',
            date: data['date'] ?? '',
            amount: data['amount'] ?? '',
            timestamp: data['timestamp']?.toDate(), // ✅ Add timestamp if needed
          );
        }).toList();

        final visibleItems = showAll
            ? allTransactions
            : allTransactions.take(3).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!showAll)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Activity',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ActivityScreen(),
                          ),
                        );
                      },
                      child: const Text('See all'),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              ...visibleItems.map((tx) => ActivityTile(tx)).toList(),
            ],
          ),
        );
      },
    );
  }
}
