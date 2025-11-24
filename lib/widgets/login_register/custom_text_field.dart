import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword ?? false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        ),
      ),
    );
  }
}
