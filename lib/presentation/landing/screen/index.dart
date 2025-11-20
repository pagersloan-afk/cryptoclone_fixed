import 'package:ecommerce_app/presentation/landing/sections/index/disclosure.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/financial_and_community.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/footer.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/login_promo_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/mortgage_and_mobile_apk_promo.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/product_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/promo_section.dart';
import 'package:flutter/material.dart';
import '../sections/index/header_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            MainSubNavigation(),
            LoginPromoSection(),
            SizedBox(height: 40),
            PromoSection(),
            SizedBox(height: 40),
            ProductSection(),
            SizedBox(height: 40),
            MortgagePromoSection(),
            SizedBox(height: 40),
            MobileAppPromoSection(),
            SizedBox(height: 40),
            FinancialGuidanceSection(),
            SizedBox(height: 40),
            CommunitySection(),
            SizedBox(height: 30),
            DisclosureSection(),
            SizedBox(height: 40),
            PremiumFooter(),
            // Add promo, product grid, footer here
          ],
        ),
      ),
    );
  }
}
