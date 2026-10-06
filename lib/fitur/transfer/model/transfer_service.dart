import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> processTransfer({
    required String tujuanId,
    required int nominal,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login');
    }

    final pengirimRef = _db.collection('users').doc(user.uid);

    final query = await _db
        .collection('users')
        .where('untarId', isEqualTo: tujuanId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('UNTAR ID tidak ditemukan');
    }

    final penerimaRef = query.docs.first.reference;

    if (penerimaRef.id == user.uid) {
      throw Exception('Tidak bisa transfer ke akun sendiri');
    }

    final mutasiPengirim = pengirimRef.collection('mutasi').doc();
    final mutasiPenerima = penerimaRef.collection('mutasi').doc();

    await _db.runTransaction((transaction) async {
      final pengirim = await transaction.get(pengirimRef);
      final penerima = await transaction.get(penerimaRef);

      if (!pengirim.exists || !penerima.exists) {
        throw Exception('Data rekening tidak ditemukan');
      }

      final dataPengirim = pengirim.data()!;
      final dataPenerima = penerima.data()!;

      final double saldoPengirim = (dataPengirim['saldo'] ?? 0).toDouble();
      final double saldoPenerima = (dataPenerima['saldo'] ?? 0).toDouble();

      final String idPengirim = dataPengirim['untarId'] ?? '';
      final String idPenerima = dataPenerima['untarId'] ?? tujuanId;

      if (saldoPengirim < nominal) {
        throw Exception('Saldo tidak cukup');
      }

      transaction.update(pengirimRef, {
        'saldo': saldoPengirim - nominal,
      });

      transaction.update(penerimaRef, {
        'saldo': saldoPenerima + nominal,
      });

      transaction.set(mutasiPengirim, {
        'judul': 'Transfer',
        'keterangan': 'Transfer ke $idPenerima',
        'nominal': nominal,
        'type': 'keluar',
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.set(mutasiPenerima, {
        'judul': 'Transfer Masuk',
        'keterangan': 'Transfer dari $idPengirim',
        'nominal': nominal,
        'type': 'masuk',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}