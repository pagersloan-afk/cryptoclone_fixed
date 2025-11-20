import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EquityLoanForm extends StatefulWidget {
  const EquityLoanForm({super.key});

  @override
  State<EquityLoanForm> createState() => _EquityLoanFormState();
}

class _EquityLoanFormState extends State<EquityLoanForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _companyNameController = TextEditingController();
  final _legalStructureController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactTitleController = TextEditingController();
  final _websiteController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _currentRevenueController = TextEditingController();
  final _currentMarginController = TextEditingController();
  final _projectedRevenueController = TextEditingController();
  final _projectedMarginController = TextEditingController();
  final _investmentAmountController = TextEditingController();
  final _useOfFundsController = TextEditingController();
  final _equityStakeController = TextEditingController();
  final _marketPositionController = TextEditingController();
  final _marketGrowthFactorsController = TextEditingController();
  final _competitiveAdvantagesController = TextEditingController();
  final _exitStrategyController = TextEditingController();
  final _exitTimeframeController = TextEditingController();
  final _signatureController = TextEditingController();
  final _signatureDateController = TextEditingController();

  // Dropdown values
  String? _regulatoryFiled;
  String? _legalIssues;
  String? _issueType;

  @override
  void dispose() {
    _companyNameController.dispose();
    _legalStructureController.dispose();
    _companyEmailController.dispose();
    _companyPhoneController.dispose();
    _contactPersonController.dispose();
    _contactTitleController.dispose();
    _websiteController.dispose();
    _businessDescriptionController.dispose();
    _currentRevenueController.dispose();
    _currentMarginController.dispose();
    _projectedRevenueController.dispose();
    _projectedMarginController.dispose();
    _investmentAmountController.dispose();
    _useOfFundsController.dispose();
    _equityStakeController.dispose();
    _marketPositionController.dispose();
    _marketGrowthFactorsController.dispose();
    _competitiveAdvantagesController.dispose();
    _exitStrategyController.dispose();
    _exitTimeframeController.dispose();
    _signatureController.dispose();
    _signatureDateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "loanType": "Equity Loan",
      "companyName": _companyNameController.text,
      "legalStructure": _legalStructureController.text,
      "companyEmail": _companyEmailController.text,
      "companyPhone": _companyPhoneController.text,
      "contactPerson": _contactPersonController.text,
      "contactTitle": _contactTitleController.text,
      "website": _websiteController.text,
      "businessDescription": _businessDescriptionController.text,
      "currentRevenue": _currentRevenueController.text,
      "currentMargin": _currentMarginController.text,
      "projectedRevenue": _projectedRevenueController.text,
      "projectedMargin": _projectedMarginController.text,
      "investmentAmount": _investmentAmountController.text,
      "useOfFunds": _useOfFundsController.text,
      "equityStake": _equityStakeController.text,
      "marketPosition": _marketPositionController.text,
      "marketGrowthFactors": _marketGrowthFactorsController.text,
      "competitiveAdvantages": _competitiveAdvantagesController.text,
      "exitStrategy": _exitStrategyController.text,
      "exitTimeframe": _exitTimeframeController.text,
      "signature": _signatureController.text,
      "signatureDate": _signatureDateController.text,
      "regulatoryFiled": _regulatoryFiled ?? "",
      "legalIssues": _legalIssues ?? "",
      "issueType": _issueType ?? "",
    };

    try {
      final res = await http.post(
        Uri.parse("http://localhost:3000/submit-equity"), // 🔑 local dev
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
                "Your Equity Loan form was submitted successfully!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _formKey.currentState!.reset();
                    setState(() {
                      _regulatoryFiled = null;
                      _legalIssues = null;
                      _issueType = null;
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
              "Equity Loan",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC20000),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              "Company Name",
              _companyNameController,
              required: true,
            ),
            _buildTextField(
              "Legal Structure (LLC, C-Corp, etc.)",
              _legalStructureController,
              required: true,
            ),
            _buildTextField(
              "Email Address",
              _companyEmailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _buildTextField(
              "Phone Number",
              _companyPhoneController,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            _buildTextField(
              "Contact Person",
              _contactPersonController,
              required: true,
            ),
            _buildTextField("Title", _contactTitleController, required: true),
            _buildTextField(
              "Website URL",
              _websiteController,
              keyboardType: TextInputType.url,
            ),

            _buildTextField(
              "Business Description",
              _businessDescriptionController,
              required: true,
              maxLines: 6,
            ),

            _buildTextField(
              "Current Revenue (Annual)",
              _currentRevenueController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              "Current Profit Margin (%)",
              _currentMarginController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              "Projected Revenue (Next 12 Months)",
              _projectedRevenueController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              "Projected Profit Margin (%)",
              _projectedMarginController,
              keyboardType: TextInputType.number,
            ),

            _buildTextField(
              "Investment Amount Requested (\$)",
              _investmentAmountController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              "Intended Use of Funds",
              _useOfFundsController,
              required: true,
              maxLines: 4,
            ),
            _buildTextField(
              "Equity Stake Offered (%)",
              _equityStakeController,
              keyboardType: TextInputType.number,
              required: true,
            ),

            _buildTextField(
              "Market Position & Competitors",
              _marketPositionController,
              required: true,
              maxLines: 4,
            ),
            _buildTextField(
              "Key Factors Driving Market Growth",
              _marketGrowthFactorsController,
              maxLines: 3,
            ),
            _buildTextField(
              "Competitive Advantages",
              _competitiveAdvantagesController,
              maxLines: 3,
            ),

            _buildTextField(
              "Exit Strategy",
              _exitStrategyController,
              required: true,
              maxLines: 6,
            ),
            _buildTextField(
              "Timeframe for Potential Exit",
              _exitTimeframeController,
            ),

            _buildDropdown(
              "Have you filed all necessary regulatory documents?",
              ["Yes", "No"],
              initialValue: _regulatoryFiled,
              required: true,
              onChanged: (v) => setState(() => _regulatoryFiled = v),
            ),
            _buildDropdown(
              "Are there any legal issues currently impacting your business?",
              ["Yes", "No"],
              initialValue: _legalIssues,
              required: true,
              onChanged: (v) => setState(() => _legalIssues = v),
            ),

            _buildTextField(
              "Signature of Authorized Representative",
              _signatureController,
              required: true,
            ),
            _buildTextField(
              "Date",
              _signatureDateController,
              keyboardType: TextInputType.datetime,
              required: true,
            ),

            _buildDropdown(
              "Choose an Issue",
              ["Funding", "Legal", "Compliance", "Other"],
              initialValue: _issueType,
              onChanged: (v) => setState(() => _issueType = v),
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
                  "Submit Equity Loan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
    String? initialValue,
    bool required = false,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: initialValue,
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
