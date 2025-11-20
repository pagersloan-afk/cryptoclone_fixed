import 'package:ecommerce_app/presentation/landing/sections/about/section_1.dart';
import 'package:ecommerce_app/presentation/landing/sections/about/section_2.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/header_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
            SizedBox(height: 40),
            HeroMarqueeSection(),
            SizedBox(height: 40),
            ThreeCardSection(),
            SizedBox(height: 40),
            CareerPromoSection(),
            SizedBox(height: 40),
            AdditionalCardsSection(),
            SizedBox(height: 40),
            HistorySection(),
            SizedBox(height: 40),
            PremiumFooter(),
          ],
        ),
      ),
    );
  }
}
