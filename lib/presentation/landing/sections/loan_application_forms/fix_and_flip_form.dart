import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FixFlipForm extends StatefulWidget {
  const FixFlipForm({super.key});

  @override
  State<FixFlipForm> createState() => _FixFlipFormState();
}

class _FixFlipFormState extends State<FixFlipForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _propertyLocationController = TextEditingController();
  final _estimatedARVController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _repaymentTermController = TextEditingController();
  final _brokerController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _homePhoneController = TextEditingController();
  final _cellPhoneController = TextEditingController();

  // Dropdown values
  String? _repaymentType;
  String? _repaymentFrequency;
  String? _coBorrower;
  String? _citizenship;
  String? _creditScore;
  String? _borrowerType;
  String? _bankrupt;
  String? _lawsuits;
  String? _felony;
  String? _foreclosure;
  String? _experience;
  String? _constructionExperience;
  String? _licenses;
  String? _purchaseAgreement;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "loanType": "Fix & Flip",
      "fullName": _fullNameController.text,
      "email": _emailController.text,
      "propertyLocation": _propertyLocationController.text,
      "estimatedARV": _estimatedARVController.text,
      "loanAmount": _loanAmountController.text,
      "repaymentType": _repaymentType ?? "",
      "repaymentFrequency": _repaymentFrequency ?? "",
      "repaymentTerm": _repaymentTermController.text,
      "broker": _brokerController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "homePhone": _homePhoneController.text,
      "cellPhone": _cellPhoneController.text,
      "coBorrower": _coBorrower ?? "",
      "citizenship": _citizenship ?? "",
      "creditScore": _creditScore ?? "",
      "borrowerType": _borrowerType ?? "",
      "bankrupt": _bankrupt ?? "",
      "lawsuits": _lawsuits ?? "",
      "felony": _felony ?? "",
      "foreclosure": _foreclosure ?? "",
      "experience": _experience ?? "",
      "constructionExperience": _constructionExperience ?? "",
      "licenses": _licenses ?? "",
      "purchaseAgreement": _purchaseAgreement ?? "",
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost:3000/submit-fix-flip"), // 🔑 local dev
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
                "Your Fix & Flip form was submitted successfully!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _formKey.currentState!.reset();
                    setState(() {
                      _repaymentType = null;
                      _repaymentFrequency = null;
                      _coBorrower = null;
                      _citizenship = null;
                      _creditScore = null;
                      _borrowerType = null;
                      _bankrupt = null;
                      _lawsuits = null;
                      _felony = null;
                      _foreclosure = null;
                      _experience = null;
                      _constructionExperience = null;
                      _licenses = null;
                      _purchaseAgreement = null;
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField("Full Name", _fullNameController, required: true),
            _buildTextField(
              "Email",
              _emailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _buildTextField(
              "Property Location",
              _propertyLocationController,
              required: true,
            ),
            _buildTextField(
              "Estimated ARV (\$)",
              _estimatedARVController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              "Requested Loan Amount (\$)",
              _loanAmountController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildDropdown(
              "Repayment Type",
              ["Interest Only", "Principal & Interest"],
              value: _repaymentType,
              onChanged: (v) => setState(() => _repaymentType = v),
            ),
            _buildDropdown(
              "Repayment Frequency",
              [
                "Weekly",
                "Monthly",
                "Quarterly",
                "Semi-Annual",
                "Annual",
                "Balloon Payment",
              ],
              value: _repaymentFrequency,
              onChanged: (v) => setState(() => _repaymentFrequency = v),
            ),
            _buildTextField(
              "Repayment Term (Years)",
              _repaymentTermController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField("Broker/Referring Party", _brokerController),
            _buildTextField("First Name", _firstNameController),
            _buildTextField("Last Name", _lastNameController),
            _buildTextField(
              "Home Phone",
              _homePhoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              "Cell Phone",
              _cellPhoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildDropdown(
              "Co-borrower?",
              ["No", "Yes"],
              value: _coBorrower,
              onChanged: (v) => setState(() => _coBorrower = v),
            ),
            _buildDropdown(
              "Citizenship",
              [
                "U.S. Citizen",
                "Perm Resident",
                "Non-Perm Resident",
                "Foreign National",
              ],
              value: _citizenship,
              onChanged: (v) => setState(() => _citizenship = v),
            ),
            _buildDropdown(
              "Credit Score Range",
              ["600–649", "650–699", "700+"],
              value: _creditScore,
              onChanged: (v) => setState(() => _creditScore = v),
            ),
            _buildDropdown(
              "Borrower Type",
              ["Individual", "LLC", "Corporation"],
              value: _borrowerType,
              onChanged: (v) => setState(() => _borrowerType = v),
            ),
            _buildDropdown(
              "Bankrupt in past 7 years?",
              ["No", "Yes"],
              value: _bankrupt,
              onChanged: (v) => setState(() => _bankrupt = v),
            ),
            _buildDropdown(
              "Active lawsuits?",
              ["No", "Yes"],
              value: _lawsuits,
              onChanged: (v) => setState(() => _lawsuits = v),
            ),
            _buildDropdown(
              "Felony/fraud conviction?",
              ["No", "Yes"],
              value: _felony,
              onChanged: (v) => setState(() => _felony = v),
            ),
            _buildDropdown(
              "Foreclosure in past 7 years?",
              ["No", "Yes"],
              value: _foreclosure,
              onChanged: (v) => setState(() => _foreclosure = v),
            ),
            _buildDropdown(
              "Fix & Flip / Buy & Hold experience?",
              ["No", "Yes"],
              value: _experience,
              onChanged: (v) => setState(() => _experience = v),
            ),
            _buildDropdown(
              "Ground up construction experience?",
              ["No", "Yes"],
              value: _constructionExperience,
              onChanged: (v) => setState(() => _constructionExperience = v),
            ),
            _buildDropdown(
              "Professional licenses?",
              ["No", "Yes"],
              value: _licenses,
              onChanged: (v) => setState(() => _licenses = v),
            ),
            _buildDropdown(
              "Accepted purchase agreement?",
              ["No", "Yes"],
              value: _purchaseAgreement,
              onChanged: (v) => setState(() => _purchaseAgreement = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Submit Fix & Flip"),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helpers
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
    bool required = false,
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
        validator: required
            ? (val) => val == null || val.isEmpty ? "Required field" : null
            : null,
      ),
    );
  }
}
