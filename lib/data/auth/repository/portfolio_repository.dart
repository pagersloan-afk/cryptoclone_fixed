import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/holding.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Holding>> fetchUserHoldings(String userId) async {
    final snapshot = await _firestore
        .collection('Users') // ✅ Capitalized to match Firestore
        .doc(userId)
        .collection('holdings')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Holding(
        symbol: data['symbol'] ?? '',
        amount: (data['amount'] as num).toDouble(),
      );
    }).toList();
  }

  // 🔜 Future support for admin console
  Future<List<Holding>> fetchAdminHoldings() async {
    // Placeholder for future admin console integration
    return [];
  }
}
