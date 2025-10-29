import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/transaction.dart' as model;

class ActivityTile extends StatelessWidget {
  final model.Transaction tx;
  const ActivityTile(this.tx, {super.key});

  String formatDate(DateTime? ts, String fallback) {
    if (ts != null) {
      return ts.toString(); // ✅ Default Dart format: "2025-10-22 04:02:01.000"
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        tx.type == 'deposit' ? Icons.download : Icons.upload,
        color: tx.type == 'deposit' ? Colors.green : Colors.red,
      ),
      title: Text(tx.label, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        formatDate(tx.timestamp, tx.date),
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Text(tx.amount, style: const TextStyle(color: Colors.white)),
    );
  }
}
