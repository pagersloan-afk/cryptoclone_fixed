import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // ✅ Needed for TimeoutException

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

  static const String devApiBase = 'http://127.0.0.1:3000';
  static const String prodApiBase = 'https://www.igegvault.com';
  static const bool useProd = false;

  String get _apiBase => useProd ? prodApiBase : devApiBase;

  Future<void> _validateKey() async {
    final input = _keyController.text.trim();
    print('🔍 validateKey triggered');
    print('🔍 Sending POST to $_apiBase/validate-ibm-key with key: $input');
    if (input.isEmpty) {
      setState(() => _status = '❌ Please enter a product key.');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$_apiBase/validate-ibm-key'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'productKey': input}),
          )
          .timeout(const Duration(seconds: 10));

      print('🔁 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _status = result['valid'] == true
              ? '✅ IBM Kubernetes linked successfully.'
              : '❌ Invalid product key.';
        });
      } else {
        setState(() {
          _status =
              '❌ Server error (${response.statusCode}). Please try again.';
        });
      }
    } on TimeoutException {
      setState(() {
        _status = '❌ Request timed out. Please try again.';
      });
    } on http.ClientException {
      setState(() {
        _status = '❌ Connection error. Check the API base URL.';
      });
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
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Link IBM Kubernetes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 700;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 600 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter your IBM product key to activate Kubernetes access:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _keyController,
                      decoration: InputDecoration(
                        hintText: 'e.g. XXXX-XXXX-XXXX-XXXX',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF1D1E33),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateKey,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Validate & Link'),
                      ),
                    ),
                    if (_status != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        _status!,
                        style: TextStyle(
                          color: _status!.startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
