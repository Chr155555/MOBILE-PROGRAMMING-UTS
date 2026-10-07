import 'package:flutter/material.dart';

import '../model/listrik_model.dart';

const Color untarRed = Color(0xFF880C04);

class TokenDialog extends StatelessWidget {
  final String nomorMeter;
  final int nominal;
  final String token;

  const TokenDialog({
    super.key,
    required this.nomorMeter,
    required this.nominal,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pembayaran Berhasil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 15),
          const Text('No. Meter', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(nomorMeter, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('Nominal', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            'Rp ${ListrikModel.formatRupiah(nominal)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text('Token Listrik', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          SelectableText(
            ListrikModel.formatToken(token),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: untarRed,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: untarRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Selesai'),
        ),
      ],
    );
  }
}
