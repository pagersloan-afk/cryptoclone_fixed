import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MutualFundForm extends StatefulWidget {
  final String? preselectedFund;
  const MutualFundForm({super.key, this.preselectedFund});

  @override
  State<MutualFundForm> createState() => _MutualFundFormState();
}

class _MutualFundFormState extends State<MutualFundForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _street2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  final _dollarsController = TextEditingController();
  final _centsController = TextEditingController();

  // Dropdowns
  String? _fundType;

  // Optional: use dropdown for country instead of free text
  final List<String> _countries = const [
    "United States",
    "Canada",
    "United Kingdom",
    "South Africa",
    "India",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _fundType = widget.preselectedFund;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _dollarsController.dispose();
    _centsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "dob": _dobController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "street": _streetController.text,
      "street2": _street2Controller.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "zip": _zipController.text,
      "country": _countryController.text,
      "fundType": _fundType ?? "",
      "dollars": _dollarsController.text,
      "cents": _centsController.text,
    };

    try {
      final res = await http.post(
        Uri.parse(
          "http://localhost:3000/submit-mutual-fund",
        ), // 🔑 backend route
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
                "Your Mutual Fund application was submitted successfully!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _formKey.currentState!.reset();
                    setState(() {
                      _fundType = null;
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
    // Page shell styled to mirror your CSS (padding, background, card)
    return Scaffold(
      body: Container(
        color: const Color(0xFFF9F9F9),
        padding: const EdgeInsets.all(24), // .mutual-fund-form-section padding
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // .mutual-fund-form radius
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05), // match CSS shadow
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24), // .mutual-fund-form padding
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Apply for a Mutual Fund",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Unlock your financial future with our robo-investing platform. "
                        "Choose a fund, enter your details, and start your journey.",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Personal Information
                      _sectionLegend("Personal Information"),
                      _tf("First Name", _firstNameController, required: true),
                      _tf("Last Name", _lastNameController, required: true),
                      _tf("Date of Birth", _dobController, required: true),
                      _tf(
                        "Email Address",
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                        required: true,
                      ),
                      _tf(
                        "Phone Number",
                        _phoneController,
                        keyboardType: TextInputType.phone,
                        required: true,
                      ),

                      const SizedBox(height: 24),

                      // Mailing Address
                      _sectionLegend("Mailing Address"),
                      _tf("Street Address", _streetController, required: true),
                      _tf("Street Address 2", _street2Controller),
                      _tf("City", _cityController, required: true),
                      _tf("State/Region", _stateController, required: true),
                      _tf("Postal/Zip Code", _zipController, required: true),

                      // ✅ Country dropdown using helper
                      _buildDropdown(
                        "Country",
                        _countries,
                        value: _countryController.text.isNotEmpty
                            ? _countryController.text
                            : null,
                        onChanged: (val) {
                          if (val != null) _countryController.text = val;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Investment Details
                      _sectionLegend("Investment Details"),
                      // ✅ Fund type dropdown using helper
                      _buildDropdown(
                        "Select Mutual Fund",
                        const ["IGEG-LOCK", "IGEG-SAVE"],
                        value: _fundType,
                        onChanged: (val) => setState(() => _fundType = val),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _tf(
                              "Dollars",
                              _dollarsController,
                              keyboardType: TextInputType.number,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _tf(
                              "Cents (0–99)",
                              _centsController,
                              keyboardType: TextInputType.number,
                              required: true,
                              extraValidator: (v) {
                                if (v == null || v.isEmpty) return null;
                                final n = int.tryParse(v);
                                if (n == null) return "Enter numbers only";
                                if (n < 0 || n > 99)
                                  return "Must be between 0 and 99";
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // CAPTCHA placeholder box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "🔒 CAPTCHA Verification Placeholder",
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit button styled to match .cta-button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00704A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
      ),
    );
  }

  // ---------- Helpers ----------

  // Section legend (mirrors <legend> styling)
  Widget _sectionLegend(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  // Text field with consistent styling and required validation
  Widget _tf(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    String? Function(String?)? extraValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black, // ✅ ensures text is always visible
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black87, // ✅ label visible
            fontSize: 14,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00704A)), // ✅ green focus
          ),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return "Required field";
          }
          if (extraValidator != null) {
            return extraValidator(value);
          }
          return null;
        },
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
        dropdownColor: const Color.fromARGB(
          255,
          234,
          229,
          229,
        ), // light background
        style: const TextStyle(color: Colors.black), // force black text
        items: options
            .map(
              (opt) => DropdownMenuItem(
                value: opt,
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
