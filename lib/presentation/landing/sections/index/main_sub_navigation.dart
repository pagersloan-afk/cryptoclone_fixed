import 'package:flutter/material.dart';

class MainSubNavigation extends StatelessWidget {
  const MainSubNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: const [MainNavigation(), SubNavigation()]);
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 10 : 14,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 241, 241), // light background
        ),
        child: isMobile
            ? Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _mainLink(
                    context,
                    '/personal',
                    'Personal',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/investing',
                    'Investing & Wealth',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/business',
                    'Business',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/commercial',
                    'Commercial',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/corporate-banking',
                    'Corporate Banking',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/about',
                    'About IGEG',
                    currentRoute,
                    isMobile,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _mainLink(
                    context,
                    '/personal',
                    'Personal',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/investing',
                    'Investing & Wealth',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/business',
                    'Business',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/commercial',
                    'Commercial',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/corporate-banking',
                    'Corporate Banking',
                    currentRoute,
                    isMobile,
                  ),
                  _mainLink(
                    context,
                    '/about',
                    'About IGEG',
                    currentRoute,
                    isMobile,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _mainLink(
    BuildContext context,
    String route,
    String label,
    String currentRoute,
    bool isMobile,
  ) {
    final isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, route),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: isMobile ? 13 : 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          if (isActive)
            Container(
              height: 2,
              width: 28,
              color: const Color(0xFFB31B1B), // brand red underline
              margin: const EdgeInsets.only(top: 4),
            ),
        ],
      ),
    );
  }
}

class SubNavigation extends StatelessWidget {
  const SubNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 8 : 10,
        ),
        decoration: const BoxDecoration(color: Colors.white),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: isMobile ? 10 : 14,
          runSpacing: 6,
          children: [
            _subLink(context, '/checking', 'Checking', currentRoute, isMobile),
            _subLink(
              context,
              '/savings',
              'Savings & CDs',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/home-loans',
              'Home Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/personal-loans',
              'Personal Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/auto-loans',
              'Auto Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(context, '/premier', 'Premier', currentRoute, isMobile),
            _subLink(
              context,
              '/mutual-funds',
              'Mutual Funds',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/fix-and-flip',
              'Fix and Flip Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/dscr-rental',
              'DSCR Rental Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/new-construction',
              'New Construction Loans',
              currentRoute,
              isMobile,
            ),
            _subLink(
              context,
              '/recent-deals',
              'Recent Deals',
              currentRoute,
              isMobile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _subLink(
    BuildContext context,
    String route,
    String label,
    String currentRoute,
    bool isMobile,
  ) {
    final isActive = currentRoute == route;

    return Column(
      children: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: isMobile ? 12 : 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        if (isActive)
          Container(
            height: 2,
            width: 24,
            color: const Color(0xFFB31B1B),
            margin: const EdgeInsets.only(top: 2),
          ),
      ],
    );
  }
}
