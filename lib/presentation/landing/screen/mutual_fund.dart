import 'package:ecommerce_app/presentation/landing/sections/index/header_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/endorsements_and_apply_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/fund_highlights_comparison_performance.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/mutual_fund_disclosure_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/mutual_funds_and_hero_banner.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/mutual_funds_and_market_canvas.dart';
import 'package:ecommerce_app/presentation/landing/sections/mutual_fund/testimonials_section.dart';
import 'package:flutter/material.dart';

class MutualFundsPage extends StatelessWidget {
  const MutualFundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // 🔵 Hero Banner
            HeaderSection(),
            MainSubNavigation(),
            MutualFundsHeroBanner(),
            SizedBox(height: 40),
            MarketCanvasSection(),
            SizedBox(height: 40),
            FundHighlightsSection(),
            SizedBox(height: 40),
            FundComparisonSection(),
            SizedBox(height: 40),
            PerformanceSection(),
            SizedBox(height: 40),
            TestimonialsSection(),
            SizedBox(height: 40),
            EndorsementsSection(),
            SizedBox(height: 40),
            ApplySection(),
            SizedBox(height: 40),
            MutualFundDisclosureSection(),
          ],
        ),
      ),
    );
  }
}
