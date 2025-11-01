import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDepositApprovalScreen extends StatelessWidget {
  const AdminDepositApprovalScreen({super.key});

  Future<void> _approveDeposit(
    String depositId,
    Map<String, dynamic> deposit,
  ) async {
    final assetAmount = deposit['assetAmount'];
    final assetType = deposit['assetType'];

    await FirebaseFirestore.instance
        .collection('deposits')
        .doc(depositId)
        .update({
          'status': 'approved', // ✅ Only update status
          'assetAmount': assetAmount, // ✅ Preserve original value
          'assetType': assetType,
        });

    await FirebaseFirestore.instance.collection('Transactions').add({
      'userId': deposit['userId'],
      'type': 'deposit',
      'label': 'Deposit of \$${deposit['amount']}',
      'date': DateTime.now().toString(),
      'amount': '+\$${deposit['amount'].toStringAsFixed(2)}',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Deposits')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deposits')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pendingDeposits = snapshot.data!.docs;

          if (pendingDeposits.isEmpty) {
            return const Center(child: Text('No pending deposits'));
          }

          return ListView.builder(
            itemCount: pendingDeposits.length,
            itemBuilder: (context, index) {
              final doc = pendingDeposits[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Deposit via ${data['network']}'),
                subtitle: Text('Amount: \$${data['amount']}'),
                trailing: ElevatedButton(
                  onPressed: () => _approveDeposit(doc.id, data),
                  child: const Text('Approve'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
