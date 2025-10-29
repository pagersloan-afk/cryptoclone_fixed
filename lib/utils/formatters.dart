import 'package:intl/intl.dart';

String formatBalance(double balance) {
  final formatted = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  ).format(balance);

  return '$formatted USD';
}
