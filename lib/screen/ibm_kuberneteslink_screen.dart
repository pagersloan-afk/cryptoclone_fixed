import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IBMKubernetesLinkScreen extends StatefulWidget {
  const IBMKubernetesLinkScreen({super.key});

  @override
  State<IBMKubernetesLinkScreen> createState() =>
      _IBMKubernetesLinkScreenState();
}

class _IBMKubernetesLinkScreenState extends State<IBMKubernetesLinkScreen> {
  final _keyController = TextEditingController();
  String? _status;
  bool _isLoading = false;

  Future<void> _validateKey() async {
    final input = _keyController.text.trim();
    setState(() {
      _isLoading = true;
      _status = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-admin-backend.com/validate-ibm-key'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productKey': input}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _status = result['valid'] == true
              ? '✅ IBM Kubernetes linked successfully.'
              : '❌ Invalid product key.';
        });
      } else {
        setState(() {
          _status = '❌ Server error. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Network error. Please check your connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link IBM Kubernetes')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your IBM product key to activate Kubernetes access:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                hintText: 'e.g. XXXX-XXXX-XXXX-XXXX',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _validateKey,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Validate & Link'),
            ),
            if (_status != null) ...[
              const SizedBox(height: 20),
              Text(
                _status!,
                style: TextStyle(
                  color: _status!.startsWith('✅') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
