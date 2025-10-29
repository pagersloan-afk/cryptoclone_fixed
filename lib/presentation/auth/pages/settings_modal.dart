import 'package:ecommerce_app/screen/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/presentation/auth/pages/signin.dart';
import 'package:intl/intl.dart';

class SettingsModal extends StatelessWidget {
  final String name;
  final String email;
  final String walletId;
  final String userStatus;
  final String appVersion;

  const SettingsModal({
    super.key,
    required this.name,
    required this.email,
    required this.walletId,
    required this.userStatus,
    required this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF4E5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Text(
                'Settings',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 24),

            _infoCard(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Inter',
                  ),
                ),
                subtitle: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),

            _section('General'),
            _settingItem(
              'Local Currency',
              trailing: Text(
                NumberFormat.simpleCurrency(
                      locale: Localizations.localeOf(context).toString(),
                    ).currencyName ??
                    'USD',
              ),
            ),

            _settingItem('Trading Currency', trailing: const Text('BTC')),
            _settingItem(
              'Push Notifications',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _settingItem(
              'Email Alerts',
              trailing: Switch(value: false, onChanged: (_) {}),
            ),
            _settingItem(
              'SMS Alerts',
              trailing: Switch(value: false, onChanged: (_) {}),
            ),
            _settingItem(
              'In-App Messages',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _settingItem('Theme', trailing: const Text('System')),

            _section('Account'),
            _settingItem(
              'Linked Payment Methods',
              trailing: const Text('2 Banks, 1 Card'),
            ),
            _settingItem('Limits & Features', trailing: Text(userStatus)),
            _settingItem(
              'Wallet ID',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(walletId, style: const TextStyle(fontSize: 12)),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: walletId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wallet ID copied')),
                      );
                    },
                  ),
                ],
              ),
            ),
            _settingItem(
              'Bank Setup & Payouts',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                final userId = FirebaseAuth.instance.currentUser!.uid;
                final stripeAccountId =
                    'acct_abc123'; // Replace with actual logic

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(
                      userId: userId,
                      stripeAccountId: stripeAccountId,
                    ),
                  ),
                );
              },
            ),

            _section('DeFi Wallet'),
            _settingItem(
              'WalletConnect',
              trailing: const Text('Secure dApp Access'),
            ),

            _section('Security'),
            _settingItem(
              'Change Password',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            _settingItem(
              '2-Step Verification',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),

            _section('Help'),
            _settingItem('Support'),
            _settingItem('Rate our app'),
            _settingItem('Terms of Service'),
            _settingItem('Privacy Policy'),
            _settingItem('Cookie Policy'),

            _section('Danger Zone'),
            _infoCard(
              child: ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  /* delete logic */
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SigninPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text('Sign Out'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'App Version: $appVersion',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Inter',
      ),
    ),
  );

  Widget _settingItem(String title, {Widget? trailing, VoidCallback? onTap}) =>
      _infoCard(
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              fontFamily: 'Inter',
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      );

  Widget _infoCard({required Widget child}) => Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}
