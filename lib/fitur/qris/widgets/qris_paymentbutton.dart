import 'package:flutter/material.dart';

class QrisPaymentButton extends StatelessWidget {
  const QrisPaymentButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  static const Color untarRed = Color(0xFF880C04);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: untarRed,foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white,)
            : const Text(
                'Bayar Sekarang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}