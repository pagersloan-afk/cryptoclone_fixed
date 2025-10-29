import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/presentation/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginAdmin() async {
    final currentContext = context; // Capture context before async

    setState(() => isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .where('username', isEqualTo: usernameController.text.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        showError(currentContext, 'Admin not found');
        return;
      }

      final admin = snapshot.docs.first.data();
      if (admin['password'] != passwordController.text.trim()) {
        showError(currentContext, 'Incorrect password');
        return;
      }

      Navigator.pushReplacement(
        currentContext,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } catch (e) {
      showError(currentContext, 'Login failed: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : loginAdmin,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
