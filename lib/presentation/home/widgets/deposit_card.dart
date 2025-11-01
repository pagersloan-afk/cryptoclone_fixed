import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepositCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const DepositCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
    final assetAmount = data['assetAmount'];
    final assetType = data['assetType'];
    final isCrypto = assetAmount != null && assetType != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deposit via ${data['network'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data['status'] == 'pending' ? '🟡 Pending approval' : '✅ Approved',
            style: TextStyle(
              color: data['status'] == 'pending'
                  ? Colors.orangeAccent
                  : Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isCrypto
                ? '$assetAmount $assetType'
                : '\$${data['amount'].toString()}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 4),
            Text(
              '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ],
          const Divider(
            color: Colors.white12,
            thickness: 0.5,
          ), // optional separator
        ],
      ),
    );
  }
}
