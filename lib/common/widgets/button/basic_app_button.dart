// In lib/common/widgets/button/basic_app_button.dart

import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 115, 62, 206),
        foregroundColor: Colors.white,
        minimumSize: Size.fromHeight(height ?? 50),
      ),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
    );
  }
}
