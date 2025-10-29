import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Future<String?> getAccountBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No user is currently signed in.');
      return null;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users') // ✅ FIXED: Capital U
          .doc(user.uid)
          .get();
      final data = doc.data();
      print('🔥 Firestore user data for ${user.uid}: $data');

      final rawBalance = data?['accountBalance'];
      final cleaned = rawBalance.toString().replaceAll(',', '');
      final parsed = double.tryParse(cleaned);
      print('💰 Parsed accountBalance: $parsed');

      return parsed?.toStringAsFixed(2);
    } catch (e) {
      print('❌ Error fetching account balance: $e');
      return null;
    }
  }
}
