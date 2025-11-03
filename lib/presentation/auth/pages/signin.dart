import 'package:ecommerce_app/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce_app/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app/presentation/auth/pages/enter_password.dart';
import 'package:ecommerce_app/presentation/auth/pages/signup.dart';
import 'package:ecommerce_app/presentation/admin/admin_dashboard.dart'; // ✅ Add your admin screen import
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailCon = TextEditingController();

  @override
  void dispose() {
    _emailCon.dispose();
    super.dispose();
  }

  Future<void> _handleContinue(BuildContext context) async {
    final email = _emailCon.text.trim();
    if (email.isEmpty) return;

    // 🔐 Navigate to password entry
    final signinReq = UserSigninReq(email: email);
    final user = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnterPasswordPage(signinReq: signinReq),
      ),
    );

    // ✅ After password entry, check admin claim
    if (user is User) {
      final tokenResult = await user.getIdTokenResult(true);
      final isAdmin = tokenResult.claims?['admin'] == true;

      if (isAdmin) {
        AppNavigator.pushReplacement(context, const AdminDashboard());
      } else {
        // Navigate to normal user dashboard or home
        Navigator.pushNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(hideBackButton: true),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          // ✅ Center the form horizontally
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ), // ✅ Cap width on desktop
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _signinText(context),
                  const SizedBox(height: 20),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _continueButton(context),
                  const SizedBox(height: 20),
                  _createAccount(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return const Text(
      'Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Enter Email'),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () => _handleContinue(context),
      title: 'Continue',
    );
  }

  Widget _createAccount(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70, // ✅ Soft contrast on dark background
          ),
          children: [
            const TextSpan(text: "Don't you have an account? "),
            TextSpan(
              text: 'Create one',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppNavigator.push(context, SignupPage());
                },
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).colorScheme.primary, // ✅ Branded highlight
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
