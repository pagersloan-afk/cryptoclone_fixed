// symbol_mapper.dart
String getBinanceSymbol(String coin) {
  switch (coin.toLowerCase()) {
    case 'bitcoin':
      return 'BTCUSDT';
    case 'ethereum':
      return 'ETHUSDT';
    case 'binancecoin':
      return 'BNBUSDT';
    default:
      return 'BTCUSDT';
  }
}
