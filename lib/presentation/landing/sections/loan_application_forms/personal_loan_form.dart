import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalLoanForm extends StatefulWidget {
  const PersonalLoanForm({super.key});

  @override
  State<PersonalLoanForm> createState() => _PersonalLoanFormState();
}

class _PersonalLoanFormState extends State<PersonalLoanForm> {
  final _formKey = GlobalKey<FormState>();

  final _loanAmountController = TextEditingController();
  final _loanPurposeController = TextEditingController();
  final _repaymentTermController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _ssnController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  String? _employmentStatus;
  String? _creditScore;

  @override
  void dispose() {
    _loanAmountController.dispose();
    _loanPurposeController.dispose();
    _repaymentTermController.dispose();
    _annualIncomeController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _ssnController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "loanType": "Personal Loan",
      "loanAmount": _loanAmountController.text,
      "loanPurpose": _loanPurposeController.text,
      "repaymentTerm": _repaymentTermController.text,
      "annualIncome": _annualIncomeController.text,
      "fullName": _fullNameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "dob": _dobController.text,
      "ssn": _ssnController.text,
      "address": _addressController.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "zip": _zipController.text,
      "employmentStatus": _employmentStatus ?? "",
      "creditScore": _creditScore ?? "",
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost:3000/submit-personal"), // 🔑 local dev
        body: body,
      );

      if (res.statusCode == 200) {
        // ✅ Success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Text("Success"),
                ],
              ),
              content: const Text(
                "Your Personal Loan form was submitted successfully!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _formKey.currentState!.reset();
                    setState(() {
                      _employmentStatus = null;
                      _creditScore = null;
                    });
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      } else {
        // ❌ Failure dialog
        showDialog(
          context: context,
          builder: (ctx) => Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: const [
                  Icon(Icons.error, color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text("Submission Failed"),
                ],
              ),
              content: Text("Server responded with status ${res.statusCode}."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      // ⚠️ Exception dialog
      showDialog(
        context: context,
        builder: (ctx) => Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: const [
                Icon(Icons.warning, color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Text("Error"),
              ],
            ),
            content: Text("Something went wrong: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Loan",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC20000),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              "Requested Loan Amount (\$)",
              _loanAmountController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              "Purpose of Loan",
              _loanPurposeController,
              keyboardType: TextInputType.text,
              required: true,
              maxLines: 4,
            ),
            _buildTextField(
              "Repayment Term (Years)",
              _repaymentTermController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              "Annual Income (\$)",
              _annualIncomeController,
              keyboardType: TextInputType.number,
              required: true,
            ),

            _buildDropdown(
              "Employment Status",
              [
                "Employed Full-Time",
                "Employed Part-Time",
                "Self-Employed",
                "Unemployed",
                "Retired",
                "Student",
                "Other",
              ],
              value: _employmentStatus,
              onChanged: (v) => setState(() => _employmentStatus = v),
            ),

            _buildDropdown(
              "Credit Score Range",
              [
                "Excellent (750+)",
                "Good (700–749)",
                "Fair (650–699)",
                "Poor (<650)",
              ],
              value: _creditScore,
              onChanged: (v) => setState(() => _creditScore = v),
            ),

            _buildTextField("Full Name", _fullNameController, required: true),
            _buildTextField(
              "Email Address",
              _emailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _buildTextField(
              "Phone Number",
              _phoneController,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            _buildTextField(
              "Date of Birth",
              _dobController,
              keyboardType: TextInputType.datetime,
              required: true,
            ),
            _buildTextField(
              "Social Security Number (SSN)",
              _ssnController,
              required: true,
              placeholder: "XXX-XX-XXXX",
            ),

            _buildTextField(
              "Street Address",
              _addressController,
              required: true,
            ),
            _buildTextField("City", _cityController, required: true),
            _buildTextField("State", _stateController, required: true),
            _buildTextField("Zip Code", _zipController, required: true),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC20000),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                ),
                child: const Text(
                  "Submit Personal Loan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    int maxLines = 1,
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) =>
                  value == null || value.isEmpty ? "Required field" : null
            : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options, {
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        // 🔑 Adjustment: force dropdown menu background to white
        dropdownColor: Colors.white,
        // 🔑 Adjustment: force selected item text color to black
        style: const TextStyle(color: Colors.black),
        items: options
            .map(
              (opt) => DropdownMenuItem(
                value: opt,
                // 🔑 Adjustment: ensure each option text is black
                child: Text(opt, style: const TextStyle(color: Colors.black)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (val) =>
            val == null || val.isEmpty ? "Required field" : null,
      ),
    );
  }
}
