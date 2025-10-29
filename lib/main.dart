import 'package:ecommerce_app/presentation/admin/admin_dashboard.dart';
import 'package:ecommerce_app/presentation/admin/admin_login.dart';
import 'package:ecommerce_app/presentation/auth/pages/signin.dart';
import 'package:ecommerce_app/presentation/auth/pages/signup.dart';
import 'package:ecommerce_app/presentation/home/pages/home.dart';
import 'package:ecommerce_app/presentation/splash/pages/splash.dart';
import 'package:ecommerce_app/screen/welcome_screen.dart';
import 'package:ecommerce_app/presentation/wallet/pages/unified_activity_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/presentation/splash/bloc/splash_cubit.dart';
import 'package:ecommerce_app/service_locator.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Stripe with your test publishable key
  Stripe.publishableKey =
      'pk_test_51SLgbsFbn4ZuXCmnhIqIRTubcyWXv73YeUONFpbtB3CS9YTaivm6jr9DKN9v6Dk9SYkBj4y8ri5cOb0ODpdu3zli00PS5oy50D';
  Stripe.merchantIdentifier = 'merchant.com.yourapp'; // Optional for Apple Pay
  await Stripe.instance.applySettings();

  // ✅ Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Initialize service locator dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your App',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
        initialRoute: '/',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/signup': (context) => const SignupPage(),
          '/signin': (context) => const SigninPage(),
          '/home': (context) => const HomePage(),
          '/main': (context) => const HomePage(),
          '/activity': (context) => UnifiedActivityScreen(
            userId: FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          '/admin-login': (context) => const AdminLoginPage(),
          '/admin-dashboard': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
