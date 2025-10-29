import 'package:flutter/material.dart';

void showLoginSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFF0D0E1C),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1B2F), Color(0xFF0D0E1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.tealAccent.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF00FFB0),
              size: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login Successful',
              style: TextStyle(
                color: Color(0xFF00FFB0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Welcome back! You’re being redirected to your dashboard.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FFB0)),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    ),
  );

  // ⏳ Auto-navigate after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.of(context, rootNavigator: true).pop(); // Close dialog
    Navigator.pushReplacementNamed(context, '/main'); // Navigate to main screen
  });
}
