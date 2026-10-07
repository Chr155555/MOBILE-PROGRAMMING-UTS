import 'package:flutter/material.dart';

class QrisScanButton extends StatelessWidget {
  const QrisScanButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  static const Color untarRed = Color(0xFF880C04);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.qr_code_scanner),
        style: ElevatedButton.styleFrom(
          backgroundColor: untarRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        label: const Text(
          "Scan QR",
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
}