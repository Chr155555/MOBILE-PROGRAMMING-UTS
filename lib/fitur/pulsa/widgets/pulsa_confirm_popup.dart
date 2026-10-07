import 'package:flutter/material.dart';

class PulsaConfirmPopup extends StatelessWidget {
  final String nomorHp;
  final String formattedAmount;
  final Color untarRed;

  const PulsaConfirmPopup({
    super.key,
    required this.nomorHp,
    required this.formattedAmount,
    this.untarRed = const Color(0xFF880C04),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Konfirmasi Pembelian',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.phone_android_rounded,
            color: Color(0xFF880C04),
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nomor Tujuan',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            nomorHp,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(height: 24),
          const Text(
            'Nominal Pulsa',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp $formattedAmount',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: untarRed,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal', style: TextStyle(color: Colors.black54)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: untarRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Lanjutkan'),
        ),
      ],
    );
  }
}
