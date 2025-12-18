
import 'package:flutter/material.dart';

class EgundemInput extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String) onChanged;
  final Widget? suffix;
  final bool errorBorder;

  const EgundemInput({
    super.key,
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.errorBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        errorBorder ? const Color(0xFFEF4444) : const Color(0xFF22314D);

    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        filled: true,
        fillColor: const Color(0xFF0B1424),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
      ),
    );
  }
}