
import 'package:flutter/material.dart';

class InputRekening extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;

  const InputRekening({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
}

class TombolRekening extends StatelessWidget {
  final String judul;
  final VoidCallback? onPressed;
  final bool loading;

  const TombolRekening({
    super.key,
    required this.judul,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF880C04),
          foregroundColor: Colors.white,
        ),
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(judul),
      ),
    );
  }
}
