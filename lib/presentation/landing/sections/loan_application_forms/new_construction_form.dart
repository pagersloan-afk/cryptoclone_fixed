import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewConstructionForm extends StatefulWidget {
  const NewConstructionForm({super.key});

  @override
  State<NewConstructionForm> createState() => _NewConstructionFormState();
}

class _NewConstructionFormState extends State<NewConstructionForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _arvController = TextEditingController();
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _arvController.dispose();
    _loanAmountController.dispose();
    _repaymentTermController.dispose();
    _brokerController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _homePhoneController.dispose();
    _cellPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "loanType": "New Construction",
      "fullName": _nameController.text,
      "email": _emailController.text,
      "propertyLocation": _locationController.text,
      "estimatedARV": _arvController.text,
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
        Uri.parse("http://localhost:3000/submit-construction"), // 🔑 local dev
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
                "Your New Construction form was submitted successfully!",
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
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Construction Loan",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC20000),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField("Full Name", _nameController, required: true),
            _buildTextField(
              "Email",
              _emailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _buildTextField(
              "Property Location",
              _locationController,
              required: true,
            ),
            _buildTextField(
              "Estimated ARV (\$)",
              _arvController,
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
              ["Yes", "No"],
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
              ["Yes", "No"],
              value: _bankrupt,
              onChanged: (v) => setState(() => _bankrupt = v),
            ),
            _buildDropdown(
              "Active lawsuits?",
              ["Yes", "No"],
              value: _lawsuits,
              onChanged: (v) => setState(() => _lawsuits = v),
            ),
            _buildDropdown(
              "Felony/fraud conviction?",
              ["Yes", "No"],
              value: _felony,
              onChanged: (v) => setState(() => _felony = v),
            ),
            _buildDropdown(
              "Foreclosure in past 7 years?",
              ["Yes", "No"],
              value: _foreclosure,
              onChanged: (v) => setState(() => _foreclosure = v),
            ),

            _buildDropdown(
              "Fix & Flip / Buy & Hold experience?",
              ["Yes", "No"],
              value: _experience,
              onChanged: (v) => setState(() => _experience = v),
            ),
            _buildDropdown(
              "Ground up construction experience?",
              ["Yes", "No"],
              value: _constructionExperience,
              onChanged: (v) => setState(() => _constructionExperience = v),
            ),
            _buildDropdown(
              "Professional licenses?",
              ["Yes", "No"],
              value: _licenses,
              onChanged: (v) => setState(() => _licenses = v),
            ),
            _buildDropdown(
              "Accepted purchase agreement?",
              ["Yes", "No"],
              value: _purchaseAgreement,
              onChanged: (v) => setState(() => _purchaseAgreement = v),
            ),

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
                  "Submit New Construction",
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
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
