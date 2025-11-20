import 'package:flutter/material.dart';

class LoginPromoSection extends StatelessWidget {
  const LoginPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400), // ✅ same as nav
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 32,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 241, 241), // ✅ background band
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _loginPanel(context, isMobile),
                  const SizedBox(height: 24),
                  _promoCard(context, isMobile),
                  const SizedBox(height: 24),
                  _phonePreview(isMobile),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _loginPanel(context, isMobile)),
                  const SizedBox(width: 32),
                  Expanded(flex: 1, child: _promoCard(context, isMobile)),
                  const SizedBox(width: 32),
                  Expanded(flex: 1, child: _phonePreview(isMobile)),
                ],
              ),
      ),
    );
  }

  // 👉 Left: Login Panel
  Widget _loginPanel(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good afternoon",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(value: false, onChanged: (_) {}),
              Text(
                "Save username",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB31B1B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 10 : 12,
                  ),
                ),
                child: Text(
                  "Sign On",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 10 : 12,
                  ),
                ),
                child: Text(
                  "Enroll",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _linkText("Forgot username or password?", isMobile),
              _linkText("Security Center", isMobile),
              _linkText("Privacy, Cookies, and Legal", isMobile),
            ],
          ),
        ],
      ),
    );
  }

  // 👉 Center: Promo Card
  Widget _promoCard(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Say hello to convenient checking",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Explore our checking options and choose the right account for you",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 10 : 12,
              ),
            ),
            child: Text(
              "Get started",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 14 : 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 👉 Right: Phone Preview
  Widget _phonePreview(bool isMobile) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/igeg_app_ui.png',
        fit: BoxFit.contain,
        height: isMobile ? 280 : 400,
      ),
    );
  }

  // Helper for link texts
  Widget _linkText(String text, bool isMobile) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isMobile ? 12 : 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
