import 'package:ecommerce_app/presentation/landing/screen/about.dart';
import 'package:ecommerce_app/presentation/landing/screen/auto_loans.dart';
import 'package:ecommerce_app/presentation/landing/screen/commercial.dart';
import 'package:ecommerce_app/presentation/landing/screen/contact.dart';
import 'package:ecommerce_app/presentation/landing/screen/index.dart';
import 'package:ecommerce_app/presentation/landing/screen/loan_form.dart';
import 'package:ecommerce_app/presentation/landing/screen/mutual_fund.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'service_locator.dart';
import 'presentation/splash/bloc/splash_cubit.dart';
import 'presentation/splash/pages/splash.dart';
import 'presentation/auth/pages/signin.dart';
import 'presentation/auth/pages/signup.dart';
import 'presentation/home/pages/home.dart';
import 'presentation/admin/admin_login.dart';
import 'presentation/admin/admin_dashboard.dart';
import 'presentation/wallet/pages/unified_activity_screen.dart';
import 'screen/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    Stripe.publishableKey =
        'pk_test_51SLgbsFbn4ZuXCmnhIqIRTubcyWXv73YeUONFpbtB3CS9YTaivm6jr9DKN9v6Dk9SYkBj4y8ri5cOb0ODpdu3zli00PS5oy50D';
    Stripe.merchantIdentifier = 'merchant.com.yourapp';
    await Stripe.instance.applySettings();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IGEG Vault',
        theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black, // ✅ general text style
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 14,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 12,
            ),
            titleLarge: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/landing': (_) => const LandingPage(),
          '/welcome': (_) => const WelcomeScreen(),
          '/signup': (_) => const SignupPage(),
          '/signin': (_) => const SigninPage(),
          '/home': (_) => const HomePage(),
          '/main': (_) => const HomePage(),
          '/activity': (_) {
            final user = FirebaseAuth.instance.currentUser;
            final uid = user?.uid ?? '';
            return UnifiedActivityScreen(userId: uid);
          },
          '/admin-login': (_) => const AdminLoginPage(),
          '/admin-dashboard': (_) => const AdminDashboard(),
          '/mutual-funds': (_) => const MutualFundsPage(),
          '/about': (_) => const AboutPage(),
          '/auto-loans': (_) => const AutoLoansPage(),
          '/commercial': (_) => const CommercialPage(),
          '/contact': (_) => const ContactPage(),
          '/apply': (context) => const LoanApplicationPortal(),
        },
      ),
    );
  }
}
