import 'package:flutter/material.dart';

import '../model/listrik_model.dart';

const Color untarRed = Color(0xFF880C04);

class ListrikNominalButton extends StatelessWidget {
  final int nominal;
  final int nominalDipilih;
  final VoidCallback onTap;

  const ListrikNominalButton({
    super.key,
    required this.nominal,
    required this.nominalDipilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final aktif = nominal == nominalDipilih;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: aktif ? untarRed : Colors.white,
        foregroundColor: aktif ? Colors.white : untarRed,
        side: const BorderSide(color: untarRed),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text('Rp ${ListrikModel.formatRupiah(nominal)}'),
    );
  }
}
