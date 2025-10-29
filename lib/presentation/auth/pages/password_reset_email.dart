import 'package:flutter/material.dart';

class PasswordResetEmailPage extends StatelessWidget {
  const PasswordResetEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailSending(),
          const SizedBox(height: 30),
          _sentEmail(),
          const SizedBox(height: 30),
          _returnToLoginButton(context),
        ],
      ),
    );
  }

  Widget _emailSending() {
    return Center(
      child: Image.asset(
        'lib/core/configs/assets/vectors/emailsent4.png',
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _sentEmail() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'We have sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _returnToLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Return to Login'),
    );
  }
}
