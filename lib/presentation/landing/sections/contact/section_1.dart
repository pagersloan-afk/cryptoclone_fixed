import 'package:flutter/material.dart';

// 🔵 Contact Hero Banner
class ContactHeroBanner extends StatelessWidget {
  const ContactHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      height: isMobile ? 240 : 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/contact.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: isMobile ? 320 : 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              "Let’s connect",
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "We’re focused on providing tailored products and services to meet the unique banking needs of commercial businesses with annual revenues ranging from \$25 million to \$2 billion.",
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 13 : 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle CTA action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4001D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
                ),
                child: const Text(
                  "Start the conversation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
