import 'package:ecommerce_app/data/auth/repository/portfolio_repository.dart';
import 'package:ecommerce_app/services/binance_portfolio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePortfolioService {
  final PortfolioRepository _repository = PortfolioRepository();
  final BinancePortfolioService _binance = BinancePortfolioService();

  Future<double> calculateLiveBalance() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final holdings = await _repository.fetchUserHoldings(userId);
    final prices = await _binance.fetchCurrentPrices(
      holdings.map((h) => h.symbol).toList(),
    );

    double total = 0.0;
    for (final h in holdings) {
      final amount = h.amount;
      final price = prices[h.symbol] ?? 0.0;
      total += amount * price;
    }
    return total;
  }
}
