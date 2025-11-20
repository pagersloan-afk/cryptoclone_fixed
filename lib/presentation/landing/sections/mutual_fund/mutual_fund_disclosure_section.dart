import 'package:flutter/material.dart';

/// 📜 Mutual Fund Disclosure Section
class MutualFundDisclosureSection extends StatelessWidget {
  const MutualFundDisclosureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final disclosureTextStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: isMobile ? 13 : 14, // slightly smaller on mobile
      color: Colors.black87,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Before investing, consider the funds' investment objectives, risks, charges, and expenses. "
            "Contact IGEG LLC for a prospectus or, if available, a summary prospectus containing this information. "
            "Read it carefully.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "Diversification and asset allocation do not ensure a profit or guarantee against loss.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "Past performance is no guarantee of future results.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "Because of their narrow focus, sector investments tend to be more volatile than investments "
            "that diversify across many sectors and companies.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 24),

          // Ordered list items
          Text(
            "1. IGEG's goal is to make financial expertise broadly accessible and effective in helping people live the lives they want. "
            "With assets under administration of \$2.2 trillion, including managed assets of \$1.2 trillion as of March 3, 2020, "
            "we focus on meeting the unique needs of a diverse set of customers: helping more than 6 million people invest their own life savings, "
            "nearly 23,000 businesses manage employee benefit programs, as well as providing nearly 12,500 advisory firms with technology solutions "
            "to invest their own clients' money.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "2. RMDs do not apply to investments in Roth IRAs or taxable accounts.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "3. Other fees and expenses, including those which apply to a continued investment in the fund, are described in the fund's current prospectus. "
            "IGEG Brokerage Services LLC, or its affiliates, receives compensation in connection with (i) access to, purchase or redemption of, and/or maintenance of positions "
            "in mutual funds and other investment products (\"funds\"), (ii) infrastructure needed to support such funds as well as additional compensation for shareholder services, "
            "start-up fees, infrastructure support and maintenance, marketing, engagement and analytics programs and/or (iii) a fund's attendance at events for IGEGBS's clients and/or representatives, "
            "and opportunities for the fund to promote its products and services. This compensation may take the form of sales loads and 12b-1 fees described in the prospectus and/or additional compensation "
            "paid by the fund, its investment adviser or an affiliate. IGEG reserves the right to change the funds available without transaction fees and reinstate the fees on any funds. "
            "IGEG will charge a short term trading fee each time you sell or exchange shares of FundsNetwork No Transaction Fee (NTF) funds held less than 60 days (short-term trade).",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "4. The Fund Evaluator is provided to help self-directed investors evaluate mutual funds based on their own needs and circumstances. "
            "The criteria entered is at the sole discretion of the user and any information obtained should not be considered an offer to buy or sell, "
            "a solicitation of an offer to buy, or a recommendation for any securities. You acknowledge that your requests for information are unsolicited "
            "and shall neither constitute, nor be considered as investment advice by IGEG Brokerage Services, LLC., IGEG Distributors Corporation, or their affiliates (collectively, \"IGEG\").",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 24),

          Text(
            "Please note: When comparing funds, please consider all important factors, including information pertaining to fund fees, fund features, and fund objectives. "
            "While funds may track an index, the indices and strategies employed in seeking to achieve an investment goal may be different. "
            "Each fund’s investment object and strategy and index tracked to achieve investment goals may differ. For new investors, funding investment minimums may be different.",
            style: disclosureTextStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "Reference ID: 5130181",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 11 : 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
