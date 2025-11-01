import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DepositHistoryWidget extends StatelessWidget {
  const DepositHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      return const Center(child: Text('User not authenticated'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('deposits')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No deposits yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final deposits = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'unknown';
          final amount = data['amount']?.toString() ?? '0.00';
          final network = data['network'] ?? 'N/A';

          return ListTile(
            title: Text(
              'Deposit via $network',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              status == 'pending' ? 'Pending approval' : 'Approved',
              style: TextStyle(
                color: status == 'pending' ? Colors.orange : Colors.green,
              ),
            ),
            trailing: Text(
              '\$$amount',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList();

        return Column(children: deposits);
      },
    );
  }
}
