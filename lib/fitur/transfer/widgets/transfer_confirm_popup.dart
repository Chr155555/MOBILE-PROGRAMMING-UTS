import 'package:flutter/material.dart';

class TransferConfirmPopup extends StatelessWidget {
  final String namaPenerima;
  final String tujuanId;
  final String formattedAmount;
  final Color untarRed;

  const TransferConfirmPopup({
    super.key,
    required this.namaPenerima,
    required this.tujuanId,
    required this.formattedAmount,
    this.untarRed = const Color(0xFF880C04),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Konfirmasi Transfer',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.send_rounded, color: Color(0xFF880C04), size: 40),
          const SizedBox(height: 12),
          Text(
            namaPenerima,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'UNTAR ID: $tujuanId',
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const Divider(height: 24),
          const Text(
            'Nominal Transfer',
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

typedef TransferConfirmDialog = TransferConfirmPopup;
