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
        title: 'Your App',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
        routes: {
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
        },
      ),
    );
  }
}
