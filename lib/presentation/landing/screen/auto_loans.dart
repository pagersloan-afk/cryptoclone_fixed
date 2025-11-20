import 'package:ecommerce_app/presentation/landing/sections/auto_loans/section_1.dart';
import 'package:ecommerce_app/presentation/landing/sections/auto_loans/section_2.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/footer.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:flutter/material.dart';
import '../sections/index/header_section.dart';

class AutoLoansPage extends StatelessWidget {
  const AutoLoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            MainSubNavigation(),
            AutoLoansHeroBanner(),
            SizedBox(height: 40),
            QuickStartCTA(),
            SizedBox(height: 40),
            AutoLoanPromoCards(),
            SizedBox(height: 40),
            AutoLoanToolsSection(),
            SizedBox(height: 40),
            AutoLoansFAQSection(),
            SizedBox(height: 30),
            PremiumFooter(),
            // Add promo, product grid, footer here
          ],
        ),
      ),
    );
  }
}
