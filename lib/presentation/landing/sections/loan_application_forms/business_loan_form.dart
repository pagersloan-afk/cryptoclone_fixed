import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusinessLoanForm extends StatefulWidget {
  const BusinessLoanForm({super.key});

  @override
  State<BusinessLoanForm> createState() => _BusinessLoanFormState();
}

class _BusinessLoanFormState extends State<BusinessLoanForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _loanAmountController = TextEditingController();
  final _annualRevenueController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryTypeController = TextEditingController();
  final _ownershipLengthController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _stateOfIncorporationController = TextEditingController();
  final _startDayController = TextEditingController();
  final _startYearController = TextEditingController();

  // Dropdown values
  String? _repaymentTerm;
  String? _creditScore;
  String? _dbaSame;
  String? _legalEntityType;
  String? _startMonth;

  // Funding purposes (checkboxes -> multi-select)
  final Map<String, bool> _fundingPurposes = {
    "Expansion": false,
    "Equipment Purchase": false,
    "Finance Accounts Receivable": false,
    "Inventory": false,
    "Marketing / Sales": false,
    "Payroll": false,
    "Purchase Vehicle(s)": false,
    "Remodel Building": false,
    "Working Capital / Cash Flow": false,
    "Refinance Debt": false,
    "Other": false,
  };

  @override
  void dispose() {
    _loanAmountController.dispose();
    _annualRevenueController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _companyPhoneController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _websiteController.dispose();
    _industryTypeController.dispose();
    _ownershipLengthController.dispose();
    _taxIdController.dispose();
    _stateOfIncorporationController.dispose();
    _startDayController.dispose();
    _startYearController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedPurposes = _fundingPurposes.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final body = {
      "loanType": "Business Loan",
      "loanAmount": _loanAmountController.text,
      "fundingPurpose": selectedPurposes.join(","), // CSV for simple form posts
      "repaymentTerm": _repaymentTerm ?? "",
      "annualRevenue": _annualRevenueController.text,
      "creditScore": _creditScore ?? "",
      "fullName": _fullNameController.text,
      "email": _emailController.text,
      "companyName": _companyNameController.text,
      "companyPhone": _companyPhoneController.text,
      "dbaSame": _dbaSame ?? "",
      "country": _countryController.text,
      "address": _addressController.text,
      "city": _cityController.text,
      "zip": _zipController.text,
      "website": _websiteController.text,
      "industryType": _industryTypeController.text,
      "legalEntityType": _legalEntityType ?? "",
      "ownershipLength": _ownershipLengthController.text,
      "taxId": _taxIdController.text,
      "startMonth": _startMonth ?? "",
      "startDay": _startDayController.text,
      "startYear": _startYearController.text,
      "stateOfIncorporation": _stateOfIncorporationController.text,
    };

    try {
      final res = await http.post(
        Uri.parse("https://www.igegvault.com/submit-business"),
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
                "Your Business Loan form was submitted successfully!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _formKey.currentState!.reset();
                    setState(() {
                      _repaymentTerm = null;
                      _creditScore = null;
                      _dbaSame = null;
                      _legalEntityType = null;
                      _startMonth = null;
                      for (final k in _fundingPurposes.keys) {
                        _fundingPurposes[k] = false;
                      }
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
              "Business Loan",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC20000),
              ),
            ),
            const SizedBox(height: 16),

            // Funding request
            _buildTextField(
              "How much do you need? (\$)",
              _loanAmountController,
              keyboardType: TextInputType.number,
              required: true,
            ),

            const SizedBox(height: 8),
            const Text(
              "What are you seeking funding for?",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._fundingPurposes.keys.map((purpose) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(purpose),
                value: _fundingPurposes[purpose],
                onChanged: (val) =>
                    setState(() => _fundingPurposes[purpose] = val ?? false),
              );
            }),

            _buildDropdown(
              "Repayment Term",
              [
                "Weekly",
                "Monthly",
                "Quarterly",
                "Semi-annual",
                "Annual",
                "Balloon",
                "Other",
              ],
              initialValue: _repaymentTerm,
              required: true,
              onChanged: (v) => setState(() => _repaymentTerm = v),
            ),

            // Business financials
            _buildTextField(
              "What's your annual revenue? (\$)",
              _annualRevenueController,
              keyboardType: TextInputType.number,
              required: true,
            ),

            _buildDropdown(
              "Personal credit score",
              [
                "Excellent (750+)",
                "Good (700–749)",
                "Fair (650–699)",
                "Poor (<650)",
              ],
              initialValue: _creditScore,
              required: false,
              onChanged: (v) => setState(() => _creditScore = v),
            ),

            // Contact info
            _buildTextField(
              "What is your name?",
              _fullNameController,
              required: true,
            ),
            _buildTextField(
              "What is your email address?",
              _emailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _buildTextField(
              "What is the name of your company?",
              _companyNameController,
              required: true,
            ),
            _buildTextField(
              "What is your phone number?",
              _companyPhoneController,
              keyboardType: TextInputType.phone,
              required: true,
            ),

            _buildDropdown(
              "DBA same as Legal Business Name?",
              ["Yes", "No"],
              initialValue: _dbaSame,
              required: true,
              onChanged: (v) => setState(() => _dbaSame = v),
            ),

            // Location
            _buildTextField(
              "Country/Region",
              _countryController,
              required: true,
            ),
            _buildTextField("Address", _addressController, required: true),
            _buildTextField("City", _cityController, required: true),
            _buildTextField(
              "Zip / Postal Code",
              _zipController,
              required: true,
            ),
            _buildTextField(
              "Business Website",
              _websiteController,
              keyboardType: TextInputType.url,
            ),

            // Business details
            _buildTextField(
              "Industry Type",
              _industryTypeController,
              required: true,
            ),
            _buildDropdown(
              "Legal Entity Type",
              [
                "Corp",
                "LLC",
                "PLLC",
                "Partnership",
                "Public",
                "S-Corp",
                "Sole Proprietorship",
                "Other",
              ],
              initialValue: _legalEntityType,
              required: true,
              onChanged: (v) => setState(() => _legalEntityType = v),
            ),
            _buildTextField(
              "Length of Ownership (Years)",
              _ownershipLengthController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              "Federal Tax ID",
              _taxIdController,
              required: true,
              placeholder: "xx-xxxxxxx",
            ),

            const SizedBox(height: 8),
            const Text(
              "Estimated Business Start Date",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    "Month",
                    [
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December",
                    ],
                    initialValue: _startMonth,
                    required: true,
                    onChanged: (v) => setState(() => _startMonth = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    "Day",
                    _startDayController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    "Year",
                    _startYearController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
              ],
            ),

            _buildTextField(
              "State of Incorporation",
              _stateOfIncorporationController,
              required: true,
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
                  "Submit Business Loan",
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
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
    String? initialValue, // use initialValue (value is deprecated)
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
        dropdownColor: const Color.fromARGB(255, 230, 218, 218),
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
