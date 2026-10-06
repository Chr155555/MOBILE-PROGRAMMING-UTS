import 'package:cloud_firestore/cloud_firestore.dart';

enum MutasiType { masuk, keluar }

class MutasiItem {
  final String id;
  final String judul;
  final String keterangan;
  final double nominal;
  final DateTime tanggal;
  final MutasiType type;

  const MutasiItem({
    required this.id,
    required this.judul,
    required this.keterangan,
    required this.nominal,
    required this.tanggal,
    required this.type,
  });

  factory MutasiItem.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;

    return MutasiItem(
      id: id,
      judul: data['judul'] ?? 'Transaksi',
      keterangan: data['keterangan'] ?? '-',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: timestamp?.toDate() ?? DateTime.now(),
      type: data['type'] == 'masuk'
          ? MutasiType.masuk
          : MutasiType.keluar,
    );
  }
}

class MutasiService {
  static Stream<List<MutasiItem>> streamMutasi(String uid) {
    return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('mutasi')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
          .map(
            (doc) => MutasiItem.fromFirestore(
              doc.id,
              doc.data(),
            ),
          )
        .toList(),
      );
  }

  static Future<void> tambahMutasi({
    required String uid,
    required String judul,
    required String keterangan,
    required double nominal,
    required MutasiType type,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('mutasi')
        .add({
      'judul': judul,
      'keterangan': keterangan,
      'nominal': nominal,
      'type': type == MutasiType.masuk ? 'masuk' : 'keluar',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

String formatRupiahMutasi(double value) {
  final s = value.round().toString();
  final result = s.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (match) => '${match[1]}.',
  );
  return 'Rp $result';
}

String formatTanggalMutasi(DateTime date) {
  const bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');

  return '${date.day} ${bulan[date.month - 1]} ${date.year} • $jam:$menit';
}