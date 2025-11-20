import 'package:flutter/material.dart';

class DisclosureSection extends StatelessWidget {
  const DisclosureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 40,
        ),
        color: const Color(0xFFF9F9F9), // light background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lead paragraph
            Text(
              "Keep in mind that investing involves risk. The value of your investment will fluctuate over time, and you may gain or lose money.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 14 : 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Ordered list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _disclosureItem(
                  context,
                  "A qualified distribution from a Roth IRA is tax-free and penalty-free. To be considered a qualified distribution, the 5-year aging requirement has to be satisfied and you must be age 59 or older or meet one of several exemptions (disability, qualified first-time home purchase, or death among them).",
                  1,
                  isMobile,
                ),
                _disclosureItem(
                  context,
                  "There is no minimum amount required to open an IGEG Go account. However, in order for us to invest your money according to the investment strategy you've chosen, your account balance must be at least \$100.",
                  2,
                  isMobile,
                ),
                _disclosureItem(
                  context,
                  "Zero account minimums and zero account fees apply to retail brokerage accounts only. Expenses charged by investments (e.g., funds, managed accounts, and certain HSAs) and commissions, interest charges, or other expenses for transactions may still apply. See igegllc.com/commissions for further details.",
                  3,
                  isMobile,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Additional paragraphs
            _paragraph(
              "The IGEG® Cash Management Account is a brokerage account designed for spending and cash management. It is not intended to serve as your main account for securities trading. Customers interested in securities trading should consider an IGEG Mutual Fund Account®.",
              isMobile,
            ),
            _paragraph(
              "IGEG Go® provides discretionary investment management, and in certain circumstances, non-discretionary financial planning, for a fee. Advisory services offered by IGEG Personal and Workplace Advisors LLC (IGEGPWA), a registered investment adviser. Brokerage services provided by IGEG Brokerage Services LLC (IGEGBS), and custodial and related services provided by National Financial Services LLC (NFS), each a member NYSE and NFS are IGEG Investments companies.",
              isMobile,
            ),
            _paragraph(
              "IGEG and the IGEG Investments logo are registered service marks of IGEG LLC.",
              isMobile,
            ),
            _paragraph("Images are for illustrative purposes only.", isMobile),
            _paragraph("© 2025 IGEG LLC. All rights reserved.", isMobile),
            _paragraph(
              "IGEG Brokerage Services LLC, Member NYSE, SIPC, PO Box 1612 Southampton, New York 11969, United States.",
              isMobile,
            ),
            const SizedBox(height: 12),
            Text(
              "5130181",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 11 : 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclosureItem(
    BuildContext context,
    String text,
    int number,
    bool isMobile,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 14 : 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 13 : 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paragraph(String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isMobile ? 12 : 13,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
}
