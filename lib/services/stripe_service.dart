import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  /// Creates and confirms a Stripe PaymentIntent
  static Future<void> makePayment({
    required int amount, // amount in cents
    String currency = 'usd',
    Map<String, String>? metadata,
  }) async {
    try {
      // 🔗 Step 1: Call Firebase Function via ngrok tunnel
      final response = await http.post(
        Uri.parse(
          'https://somatopleuric-automatically-allison.ngrok-free.dev/ecommerce-apps-project/us-central1/api/create-payment-intent',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'currency': currency,
          'metadata': metadata ?? {},
        }),
      );

      final jsonResponse = json.decode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      if (clientSecret == null) {
        throw Exception('Missing clientSecret from backend');
      }

      // 💳 Step 2: Confirm payment with Stripe SDK
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
      );

      print('✅ Payment successful');
    } catch (e) {
      print('❌ Payment failed: $e');
      // Optionally show a dialog or log to Crashlytics
    }
  }
}
