import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawModal extends StatefulWidget {
  final double balance;
  final Function(double amount, Map<String, String>) onWithdrawConfirmed;

  const WithdrawModal({
    super.key,
    required this.balance,
    required this.onWithdrawConfirmed,
  });

  @override
  State<WithdrawModal> createState() => _WithdrawModalState();
}

class _WithdrawModalState extends State<WithdrawModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _nameOnAccountController = TextEditingController();
  String _accountType = 'Checking';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final details = {
        'bankName': _bankNameController.text,
        'accountNumber': _accountNumberController.text,
        'routingNumber': _routingNumberController.text,
        'nameOnAccount': _nameOnAccountController.text,
        'accountType': _accountType,
      };
      HapticFeedback.mediumImpact(); // ✅ Tactile feedback
      widget.onWithdrawConfirmed(amount, details);
      Navigator.pop(context);
    }
  }

  InputDecoration _inputStyle(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: const Color(0xFF2A2B3D),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.account_balance_wallet, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Withdraw Funds',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle('Amount (USD)'),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null ||
                      amount <= 0 ||
                      amount > widget.balance) {
                    return 'Enter a valid amount up to \$${widget.balance.toStringAsFixed(2)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bankNameController,
                decoration: _inputStyle('Bank Name'),
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle('Account Number'),
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _routingNumberController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle('Routing Number'),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value == null || value.length != 9
                    ? 'Must be 9 digits'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameOnAccountController,
                decoration: _inputStyle('Name on Account'),
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _accountType,
                items: const [
                  DropdownMenuItem(value: 'Checking', child: Text('Checking')),
                  DropdownMenuItem(value: 'Savings', child: Text('Savings')),
                  DropdownMenuItem(
                    value: 'Business Checking',
                    child: Text('Business Checking'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _accountType = value ?? 'Checking'),
                decoration: _inputStyle('Account Type'),
                dropdownColor: const Color(0xFF2A2B3D),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Withdrawal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
