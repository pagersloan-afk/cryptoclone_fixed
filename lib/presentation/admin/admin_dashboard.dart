import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce_app/presentation/admin/admin_deposit_approval_screen.dart';
import 'package:ecommerce_app/presentation/auth/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/price_service.dart';
import 'package:ecommerce_app/services/portfolio_price_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SystemWalletEditor(),
          const Divider(),

          // ✅ Deposit Approval Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDepositApprovalScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('Approve Deposits'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const Divider(),

          // ✅ User List View
          const Expanded(child: UserListView()),
        ],
      ),
    );
  }
}

class SystemWalletEditor extends StatefulWidget {
  const SystemWalletEditor({super.key});

  @override
  State<SystemWalletEditor> createState() => _SystemWalletEditorState();
}

class _SystemWalletEditorState extends State<SystemWalletEditor> {
  final controller = TextEditingController();
  final Map<String, TextEditingController> controllers = {};
  final List<String> supportedAssets = ['BTC', 'ETH', 'USDT', 'XRP'];

  @override
  void initState() {
    super.initState();
    for (var asset in supportedAssets) {
      controllers[asset] = TextEditingController();
    }

    FirebaseFirestore.instance
        .collection('SystemConfig')
        .doc('depositWallets')
        .get()
        .then((doc) {
          for (var asset in supportedAssets) {
            controllers[asset]?.text = doc[asset] ?? '';
          }
        });
  }

  Future<void> updateWallets() async {
    final data = {
      for (var asset in supportedAssets) asset: controllers[asset]?.text ?? '',
    };
    await FirebaseFirestore.instance
        .collection('SystemConfig')
        .doc('depositWallets')
        .set(data);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Wallet addresses updated')));
  }

  @override
  Widget build(BuildContext context) {
    final supportedAssets = ['BTC', 'ETH', 'USDT', 'XRP'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deposit Wallet Addresses',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // 🔽 Scrollable wallet fields
          SizedBox(
            height: 240, // ✅ Adjust height as needed
            child: SingleChildScrollView(
              child: Column(
                children: supportedAssets
                    .map(
                      (asset) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: controllers[asset],
                          decoration: InputDecoration(
                            labelText: '$asset Wallet Address',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: updateWallets,
            child: const Text('Save Wallets'),
          ),
        ],
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final data = user.data() as Map<String, dynamic>;

            return ListTile(
              title: Text('${data['firstName']} ${data['lastName']}'),
              subtitle: Text(
                'Email: ${data['email']}\nStatus: ${data['status'] ?? 'notVerified'}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditUserPage(userId: user.id, userData: data),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EditUserPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditUserPage({required this.userId, required this.userData, super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController walletController;
  late TextEditingController balanceController;
  final depositAmountController = TextEditingController();

  final List<String> supportedAssets = [
    'usdt',
    'doge',
    'ada',
    'avax',
    'axs',
    'bch',
    'bnb',
    'usdc',
    'btc',
    'dot',
    'a',
    'etc',
    'eth',
    'five',
    'kai',
    'link',
    'ltc',
    'pol',
    'shib',
    'sol',
    'trx',
    'uni',
    'xlm',
    'xrp',
    'xtz',
  ];
  String selectedAsset = 'btc';
  String selectedStatus = 'notVerified';

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(
      text: widget.userData['firstName'],
    );
    lastNameController = TextEditingController(
      text: widget.userData['lastName'],
    );
    emailController = TextEditingController(text: widget.userData['email']);
    walletController = TextEditingController(text: widget.userData['walletId']);
    balanceController = TextEditingController(
      text: widget.userData['accountBalance']?.toString() ?? '',
    );
    selectedStatus = widget.userData['status'] ?? 'notVerified';
  }

  void updateUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .update({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'walletId': walletController.text,
          'accountBalance': double.tryParse(balanceController.text) ?? 0.0,
          'status': selectedStatus,
        });
    Navigator.pop(context);
  }

  void deleteUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .delete();
    Navigator.pop(context);
  }

  Future<void> updateWalletBalanceFromPortfolio() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();
      final userData = userDoc.data();
      if (userData == null) return;

      final portfolioRaw = userData['portfolio_assets'];
      if (portfolioRaw == null || portfolioRaw is! Map) return;

      final portfolio = Map<String, dynamic>.from(portfolioRaw);
      final prices = await fetchLivePrices(portfolio.keys.toList());
      final totalValue = calculatePortfolioValue(portfolio, prices);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update({'accountBalance': totalValue});

      setState(() {
        balanceController.text = totalValue.toStringAsFixed(2);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Wallet balance updated to \$${totalValue.toStringAsFixed(2)}',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update wallet balance')),
      );
    }
  }

  Future<void> depositToWallet() async {
    final symbol = selectedAsset;
    final fiatAmount = double.tryParse(depositAmountController.text) ?? 0.0;

    if (symbol.isEmpty || fiatAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid deposit input')));
      return;
    }

    try {
      // 🔹 Fetch live price for selected asset
      final assetPrice = await fetchLivePrice(symbol);
      if (assetPrice == null || assetPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch asset price')),
        );
        return;
      }

      // 🔹 Convert fiat to actual asset quantity
      final assetAmount = fiatAmount / assetPrice;

      // 🔹 Log deposit for audit
      final adminId = FirebaseFirestore.instance.app.options.projectId;
      final depositRef = FirebaseFirestore.instance
          .collection('deposits')
          .doc();

      await depositRef.set({
        'userId': widget.userId,
        'symbol': symbol,
        'amount': assetAmount,
        'fiatValue': fiatAmount,
        'priceAtDeposit': assetPrice,
        'status': 'confirmed',
        'source': 'manual',
        'adminId': adminId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 🔹 Update holdings
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('holdings')
          .doc(symbol)
          .set({
            'symbol': symbol,
            'amount': FieldValue.increment(assetAmount),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      // 🔹 Recalculate portfolio balance
      await updateWalletBalanceFromPortfolio();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deposited \$${fiatAmount.toStringAsFixed(2)} worth of $symbol',
          ),
        ),
      );
    } catch (e, stack) {
      print('Deposit error: $e');
      print('Stack trace: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to deposit to wallet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ['Verified', 'notVerified'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              AppNavigator.pushAndRemove(context, const SigninPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: walletController,
              decoration: const InputDecoration(labelText: 'Wallet ID'),
            ),
            TextField(
              controller: balanceController,
              decoration: const InputDecoration(labelText: 'Account Balance'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: statusOptions.contains(selectedStatus)
                  ? selectedStatus
                  : 'notVerified',
              items: statusOptions.map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) => setState(() => selectedStatus = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateUser, child: const Text('Update')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteUser,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateWalletBalanceFromPortfolio,
              child: const Text('Update Account Balance from Portfolio'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Deposit to Wallet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedAsset,
              decoration: const InputDecoration(labelText: 'Asset Symbol'),
              items: supportedAssets.map((symbol) {
                return DropdownMenuItem(
                  value: symbol,
                  child: Text(symbol.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedAsset = value!),
            ),
            TextField(
              controller: depositAmountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: depositToWallet,
              child: const Text('Confirm Deposit'),
            ),
          ],
        ),
      ),
    );
  }
}
