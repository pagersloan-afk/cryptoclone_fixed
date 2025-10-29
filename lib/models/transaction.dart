import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String type;
  final String label;
  final String date;
  final String amount;
  final DateTime? timestamp;
  final String? userId;

  const Transaction({
    required this.type,
    required this.label,
    required this.date,
    required this.amount,
    this.timestamp,
    this.userId,
  });

  factory Transaction.fromMap(Map<String, dynamic> data) {
    final ts = data['timestamp'];
    return Transaction(
      type: data['type'] ?? '',
      label: data['label'] ?? '',
      date: data['date'] ?? '', // fallback if timestamp is missing
      amount: data['amount']?.toString() ?? '',
      timestamp: ts is Timestamp ? ts.toDate() : null,
      userId: data['userId'],
    );
  }
}
