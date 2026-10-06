import 'package:flutter/material.dart';
import '../model/mutasi_model.dart';

const Color merahUntar = Color(0xFF880C04);

class MutasiCard extends StatelessWidget {
  final MutasiItem item;
  const MutasiCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool masuk = item.type == MutasiType.masuk;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: masuk
                  ? Colors.green.withValues(alpha: 0.12)
                  : merahUntar.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              masuk
                ? Icons.south_west
                : Icons.north_east,
              color: masuk
                ? Colors.green
                : merahUntar,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.judul,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.keterangan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatTanggalMutasi(item.tanggal),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${masuk ? '+' : '-'}${formatRupiahMutasi(item.nominal)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: masuk
                ? Colors.green
                : merahUntar,
            ),
          ),
        ],
      ),
    );
  }
}

class MutasiKosong extends StatelessWidget {
  const MutasiKosong({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 55,
              color: Colors.black38,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada mutasi rekening',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Transaksi yang kamu lakukan akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}