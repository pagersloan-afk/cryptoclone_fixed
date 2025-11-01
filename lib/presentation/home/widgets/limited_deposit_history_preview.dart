import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/presentation/home/widgets/deposit_card.dart';
import 'package:ecommerce_app/screen/full_deposit_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LimitedDepositHistoryPreview extends StatelessWidget {
  const LimitedDepositHistoryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(
        child: Text(
          'User not logged in',
          style: TextStyle(color: Colors.white70),
        ),
      );
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
              'No recent deposits found',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final maxVisible = 3;
        final visibleDeposits = snapshot.data!.docs.take(maxVisible).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleDeposits.length,
              itemBuilder: (context, index) {
                final data =
                    visibleDeposits[index].data() as Map<String, dynamic>;
                return DepositCard(data: data);
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FullDepositHistoryScreen(),
                    ),
                  );
                },
                child: const Text(
                  'More',
                  style: TextStyle(color: Colors.purpleAccent),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
