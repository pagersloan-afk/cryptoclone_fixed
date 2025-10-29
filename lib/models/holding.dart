class Holding {
  final String symbol;
  final double amount;

  Holding({required this.symbol, required this.amount});

  factory Holding.fromMap(Map<String, dynamic> data) {
    return Holding(
      symbol: data['symbol'] ?? '',
      amount: (data['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'symbol': symbol, 'amount': amount};
  }
}
