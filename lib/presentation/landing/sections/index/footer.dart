import 'package:flutter/material.dart';

class PremiumFooter extends StatelessWidget {
  const PremiumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      color: const Color(0xFFf3f3f3), // light neutral background
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 24 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟦 Footer Navigation
              Wrap(
                spacing: isMobile ? 16 : 24,
                runSpacing: 12,
                children: [
                  _footerLink(context, "Privacy Policy", isMobile),
                  _footerLink(context, "Terms of Use", isMobile),
                  _footerLink(context, "Accessibility", isMobile),
                  _footerLink(context, "Security", isMobile),
                  _footerLink(context, "Legal", isMobile),
                ],
              ),
              const SizedBox(height: 32),

              // 🟨 Legal Disclaimers
              Text(
                "Investment and Insurance Products are:",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet(
                    context,
                    "Not Insured by the FDIC or Any Federal Government Agency",
                    isMobile,
                  ),
                  _bullet(
                    context,
                    "Not a Deposit or Other Obligation of, or Guaranteed by, the Bank or Any Bank Affiliate",
                    isMobile,
                  ),
                  _bullet(
                    context,
                    "Subject to Investment Risks, Including Possible Loss of the Principal Amount Invested",
                    isMobile,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _paragraph(
                context,
                "Investment and insurance products are offered through IGEG LLC Advisors, a non-bank affiliate of Investors Group of East Gate LLC.",
                isMobile,
              ),

              const SizedBox(height: 24),

              // 🟩 Accessibility
              _paragraph(
                context,
                "Mobile banking accessibility may vary by device. Compatible with iPhone®, iPad®, Android™, and other supported platforms.",
                isMobile,
              ),

              const SizedBox(height: 24),

              // 🟪 Trademarks
              _paragraph(
                context,
                "Android, Google Pay and the Google Play logo are trademarks of Google LLC. Chrome is a trademark of Google LLC.",
                isMobile,
              ),
              _paragraph(
                context,
                "Apple, the Apple logo, iPhone, iPad, Mac and Safari are trademarks of Apple Inc., registered in the U.S. and other countries.",
                isMobile,
              ),

              const SizedBox(height: 24),

              // 🟥 Meta & Regulatory
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _paragraph(
                          context,
                          "PM-09282026-7798034.1.1   |   LRC-0325",
                          isMobile,
                        ),
                        _paragraph(
                          context,
                          "© 2025 IGEG LLC. All rights reserved. Member FDIC. Equal Housing Lender",
                          isMobile,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Image.asset(
                            "assets/icons/equal-housing-logo.png",
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _paragraph(
                                context,
                                "PM-09282026-7798034.1.1   |   LRC-0325",
                                isMobile,
                              ),
                              _paragraph(
                                context,
                                "© 2025 IGEG LLC. All rights reserved. Member FDIC. Equal Housing Lender",
                                isMobile,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          "assets/icons/equal-housing-logo.png",
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔗 Footer link
  Widget _footerLink(BuildContext context, String label, bool isMobile) {
    return InkWell(
      onTap: () {},
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isMobile ? 13 : 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // • Bullet item
  Widget _bullet(BuildContext context, String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: isMobile ? 14 : 16, color: Colors.black),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 12 : 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Paragraph helper
  Widget _paragraph(BuildContext context, String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isMobile ? 12 : 13,
          color: Colors.black87,
        ),
      ),
    );
  }
}
