import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ExchangeService {
  // 🔹 Existing method for swaps and deposits
  static Stream<QuerySnapshot> getExchangeHistory(String userId) {
    return FirebaseFirestore.instance
        .collection('exchange_history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 🔹 Existing method for fund transfers
  static Stream<QuerySnapshot> getTransactionHistory(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 🔹 Optional: Filter transactions by type
  static Stream<QuerySnapshot> getTransactionHistoryByType(
    String userId,
    String type,
  ) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 🔹 Optional: Unified activity feed (one-time fetch)
  static Future<List<Map<String, dynamic>>> getUnifiedActivity(
    String userId,
  ) async {
    final exchangeSnapshot = await FirebaseFirestore.instance
        .collection('exchange_history')
        .where('userId', isEqualTo: userId)
        .get();

    final transactionSnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .get();

    final exchangeData = exchangeSnapshot.docs.map((doc) {
      final data = doc.data();
      data['source'] = 'exchange';
      return data;
    });

    final transactionData = transactionSnapshot.docs.map((doc) {
      final data = doc.data();
      data['source'] = 'transaction';
      return data;
    });

    final combined = [...exchangeData, ...transactionData];
    combined.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return combined;
  }

  // 🔹 Optional: Unified activity feed (live stream)
  static Stream<List<Map<String, dynamic>>> getLiveUnifiedActivity(
    String userId,
  ) {
    final exchangeStream = FirebaseFirestore.instance
        .collection('exchange_history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    final transactionStream = FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Rx.combineLatest2(exchangeStream, transactionStream, (
      QuerySnapshot exchangeSnap,
      QuerySnapshot transactionSnap,
    ) {
      final exchangeData = exchangeSnap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['source'] = 'exchange';
        return data;
      });

      final transactionData = transactionSnap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['source'] = 'transaction';
        return data;
      });

      final combined = [...exchangeData, ...transactionData];
      combined.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      return combined;
    });
  }
}
