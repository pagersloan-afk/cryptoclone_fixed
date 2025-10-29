import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates or updates a user's wallet with the given assets.
  /// Each asset is stored under Users/{userId}/holdings/{symbol}
  Future<void> createOrUpdateWallet(
    String userId,
    Map<String, double> assets,
  ) async {
    final holdingsRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('holdings');

    for (final entry in assets.entries) {
      await holdingsRef.doc(entry.key).set({
        'symbol': entry.key,
        'amount': entry.value,
        'updatedAt': FieldValue.serverTimestamp(), // ✅ Timestamp for audit
      }, SetOptions(merge: true)); // ✅ Merge to preserve existing fields
    }
  }
}
