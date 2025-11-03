import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/presentation/home/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Timer? _verificationTimer;

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _addressLine1Con = TextEditingController();
  final TextEditingController _addressLine2Con = TextEditingController();
  final TextEditingController _postalCodeCon = TextEditingController();

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<dynamic> countries = [];
  List<dynamic> allCountries = [];
  List<dynamic> allStates = [];
  List<dynamic> allStateWithCities = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  String? getCountryId(String? countryName) {
    final match = allCountries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => null,
    );
    return match?['id']?.toString();
  }

  String? getCountryCode(String? countryName) {
    final match = allCountries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => null,
    );
    return match?['iso2'];
  }

  String? getStateCode(String? stateName, String? countryName) {
    if (stateName == null || countryName == null) return null;

    final countryId = getCountryId(countryName);

    final match = allStates.firstWhere(
      (s) =>
          s['name'].toString().toLowerCase().trim() ==
              stateName.toLowerCase().trim() &&
          s['country_id'].toString() == countryId,
      orElse: () => null,
    );

    print('Matched State Object: $match');
    return match?['iso2']; // or 'state_code' if your states.json uses that
  }

  List<String> getCitiesForState(String? countryName, String? stateName) {
    final countryId = getCountryId(countryName);
    final stateCode = getStateCode(stateName, countryName);

    print('Country: $countryName → ID: $countryId');
    print('State: $stateName → Code: $stateCode');

    final match = allStateWithCities.firstWhere(
      (s) =>
          s['state_code'] == stateCode &&
          s['country_id'].toString() == countryId,
      orElse: () => null,
    );

    print('Cities: ${match?['cities']}');

    if (match == null || match['cities'] == null) return [];
    return List<String>.from(match['cities'].map((c) => c['name']));
  }

  Future<void> loadJsonData() async {
    countries = await loadJson('countries.json');
    allCountries = await loadJson('countries.json');
    allStates = await loadJson('states.json');
    allStateWithCities = await loadJson('states-cities.json');
    setState(() {});
  }

  Future<List<dynamic>> loadJson(String fileName) async {
    final data = await rootBundle.loadString('assets/data/$fileName');
    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480,
            ), // ✅ Desktop-friendly width
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildField('First Name', controller: _firstNameCon),
                    _buildField('Last Name', controller: _lastNameCon),
                    _buildField('Email', controller: _emailCon),
                    _buildField(
                      'Password',
                      controller: _passwordCon,
                      obscure: true,
                    ),
                    _buildField('Phone Number', controller: _phoneCon),
                    _buildField('Address Line 1', controller: _addressLine1Con),
                    _buildField(
                      'Address Line 2',
                      controller: _addressLine2Con,
                      requiredField: false,
                    ),

                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Country',
                      selectedCountry,
                      allCountries.map((c) => c['name'] as String).toList(),
                      (value) {
                        setState(() {
                          selectedCountry = value;
                          selectedState = null;
                          selectedCity = null;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildDropdown(
                      'State',
                      selectedState,
                      allStates
                          .where(
                            (s) =>
                                s['country_code'] ==
                                getCountryCode(selectedCountry),
                          )
                          .map((s) => s['name'] as String)
                          .toList(),
                      (value) {
                        setState(() {
                          selectedState = value;
                          selectedCity = null;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildDropdown(
                      'City',
                      selectedCity,
                      getCitiesForState(selectedCountry, selectedState),
                      (value) {
                        setState(() => selectedCity = value);
                      },
                    ),

                    _buildField('Postal Code', controller: _postalCodeCon),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label, {
    required TextEditingController controller,
    bool obscure = false,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        enabled: !isLoading,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        validator: requiredField
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: isLoading ? null : onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailCon.text.trim(),
            password: _passwordCon.text.trim(),
          );

      await userCredential.user?.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
            'userId': userCredential.user!.uid,
            'firstName': _firstNameCon.text.trim(),
            'lastName': _lastNameCon.text.trim(),
            'email': _emailCon.text.trim(),
            'phoneNumber': _phoneCon.text.trim(),
            'addressLine1': _addressLine1Con.text.trim(),
            'addressLine2': _addressLine2Con.text.trim(),
            'city': selectedCity ?? '',
            'state': selectedState ?? '',
            'country': selectedCountry ?? '',
            'postalCode': _postalCodeCon.text.trim(),
            'accountBalance': '0.00',
            'status': 'Not verified',
            'walletId': '',
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email to verify your account'),
          backgroundColor: Colors.green,
        ),
      );

      _startVerificationCheck();
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else {
        message = e.message ?? 'An unexpected error occurred.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _startVerificationCheck() {
    _verificationTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(firstname: _firstNameCon.text.trim()),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    _phoneCon.dispose();
    _addressLine1Con.dispose();
    _addressLine2Con.dispose();
    _postalCodeCon.dispose();
    super.dispose();
  }
}
