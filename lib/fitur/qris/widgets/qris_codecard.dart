import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrisCodeCard extends StatelessWidget {
  const QrisCodeCard({
    super.key,
    required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: QrImageView(
        data: data,
        size: 220,
      ),
    );
  }
}