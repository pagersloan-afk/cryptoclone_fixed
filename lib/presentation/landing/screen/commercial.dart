import 'package:ecommerce_app/presentation/landing/sections/commercial/section_1.dart';
import 'package:ecommerce_app/presentation/landing/sections/commercial/section_2.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/disclosure.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/footer.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:flutter/material.dart';
import '../sections/index/header_section.dart';

class CommercialPage extends StatelessWidget {
  const CommercialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            MainSubNavigation(),
            CommercialHeroBanner(),
            SizedBox(height: 40),
            CommercialInsightsSection(),
            SizedBox(height: 40),
            CompareButtonSection(),
            SizedBox(height: 40),
            StrategyInsightsSection(),
            SizedBox(height: 40),
            BenefitsResourcesSection(),
            SizedBox(height: 40),
            CommercialContactCTA(),
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
