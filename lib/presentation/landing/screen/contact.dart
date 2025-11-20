import 'package:ecommerce_app/presentation/landing/sections/contact/contact_form_section.dart';
import 'package:ecommerce_app/presentation/landing/sections/contact/section_1.dart';
import 'package:ecommerce_app/presentation/landing/sections/contact/section_2.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/footer.dart';
import 'package:ecommerce_app/presentation/landing/sections/index/main_sub_navigation.dart';
import 'package:flutter/material.dart';
import '../sections/index/header_section.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            MainSubNavigation(),
            ContactHeroBanner(),
            SizedBox(height: 40),
            ContactFormSection(),
            SizedBox(height: 40),
            ContactLocationSection(),
            SizedBox(height: 30),
            PremiumFooter(),
            // Add promo, product grid, footer here
          ],
        ),
      ),
    );
  }
}
