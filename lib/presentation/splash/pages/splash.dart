import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (kIsWeb) {
        // 🌐 Web visitors → Landing page
        Navigator.pushReplacementNamed(context, '/landing');
      } else {
        // 📱 APK/mobile users → Welcome/auth flow
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔰 App Logo
            Image.asset(
              'assets/images/app_logo.png', // Replace with your logo path
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 10),
            const Text(
              '...',
              style: TextStyle(
                color: Color(0xFF00FFB0),
                fontSize: 23,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
