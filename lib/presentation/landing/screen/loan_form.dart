import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/auto_loan_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/business_loan_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/dscr_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/equity_loan_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/fix_and_flip_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/new_construction_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/personal_loan_form.dart';
import 'package:ecommerce_app/presentation/landing/sections/loan_application_forms/rental_form.dart';
import 'package:flutter/material.dart';

class LoanApplicationPortal extends StatefulWidget {
  const LoanApplicationPortal({super.key});

  @override
  State<LoanApplicationPortal> createState() => _LoanApplicationPortalState();
}

class _LoanApplicationPortalState extends State<LoanApplicationPortal> {
  String _selectedForm = "fixFlip"; // default form

  void _showForm(String formId) {
    setState(() {
      _selectedForm = formId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 24 : 48,
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                const Text(
                  "Start Your Loan Application",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC20000),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Select a loan type to begin",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Loan Selector
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _loanButton("Fix & Flip", "fixFlip"),
                    _loanButton("DSCR Rental", "dscr"),
                    _loanButton("New Construction", "newConstruction"),
                    _loanButton("Rental Loan", "rental"),
                    _loanButton("Personal Loan", "personal"),
                    _loanButton("Auto Loan", "auto"),
                    _loanButton("Business Loan", "business"),
                    _loanButton("Equity Loan", "equity"),
                  ],
                ),
                const SizedBox(height: 32),

                // Forms
                if (_selectedForm == "fixFlip") const FixFlipForm(),
                if (_selectedForm == "dscr") const DSCRForm(),
                if (_selectedForm == "newConstruction")
                  const NewConstructionForm(),
                if (_selectedForm == "rental") const RentalForm(),
                if (_selectedForm == "personal") const PersonalLoanForm(),
                if (_selectedForm == "auto") const AutoLoanForm(),
                if (_selectedForm == "business") const BusinessLoanForm(),
                if (_selectedForm == "equity") const EquityLoanForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loanButton(String label, String formId) {
    final isSelected = _selectedForm == formId;
    return ElevatedButton(
      onPressed: () => _showForm(formId),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFC20000) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFFC20000),
        side: const BorderSide(color: Color(0xFFC20000)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
