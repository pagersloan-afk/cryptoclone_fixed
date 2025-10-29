import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _addressLine1Con = TextEditingController();
  final TextEditingController _addressLine2Con = TextEditingController();
  final TextEditingController _cityCon = TextEditingController();
  final TextEditingController _stateCon = TextEditingController();
  final TextEditingController _countryCon = TextEditingController();
  final TextEditingController _postalCodeCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildField('First Name', controller: _firstNameCon),
              _buildField('Last Name', controller: _lastNameCon),
              _buildField('Email', controller: _emailCon),
              _buildField('Password', controller: _passwordCon, obscure: true),
              _buildField('Phone Number', controller: _phoneCon),
              _buildField('Address Line 1', controller: _addressLine1Con),
              _buildField('Address Line 2', controller: _addressLine2Con),
              _buildField('City', controller: _cityCon),
              _buildField('State', controller: _stateCon),
              _buildField('Country', controller: _countryCon),
              _buildField('Postal Code', controller: _postalCodeCon),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label, {
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
              'city': _cityCon.text.trim(),
              'state': _stateCon.text.trim(),
              'country': _countryCon.text.trim(),
              'postalCode': _postalCodeCon.text.trim(),
              'accountBalance': '0.00',
              'status': 'Not verified',
              'walletId': '',
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created. Please verify your email.'),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'An account already exists with that email.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        } else {
          message = e.message ?? 'An unexpected error occurred.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    _phoneCon.dispose();
    _addressLine1Con.dispose();
    _addressLine2Con.dispose();
    _cityCon.dispose();
    _stateCon.dispose();
    _countryCon.dispose();
    _postalCodeCon.dispose();
    super.dispose();
  }
}
