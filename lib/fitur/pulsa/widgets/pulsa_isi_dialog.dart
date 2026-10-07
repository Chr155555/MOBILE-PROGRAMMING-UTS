import 'package:flutter/material.dart';

import '../model/pulsa_model.dart';

const Color untarRed = Color(0xFF880C04);

class PulsaIsiDialog extends StatelessWidget {
  final String nomorHp;
  final int nominal;

  const PulsaIsiDialog({
    super.key,
    required this.nomorHp,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pembelian Berhasil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 15),
          const Text('Nomor HP', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(nomorHp, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('Nominal Pulsa', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            'Rp ${PulsaModel.formatRupiah(nominal)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
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
