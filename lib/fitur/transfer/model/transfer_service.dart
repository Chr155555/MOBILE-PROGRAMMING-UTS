import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> checkRecipient(String tujuanId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Pengguna belum login');
    if (tujuanId.isEmpty) throw Exception('UNTAR ID tujuan harus diisi');

    var query = await _db
        .collection('users')
        .where('untarId', isEqualTo: tujuanId)
        .limit(1)
        .get();

    if (query.docs.isEmpty && int.tryParse(tujuanId) != null) {
      query = await _db
          .collection('users')
          .where('untarId', isEqualTo: int.parse(tujuanId))
          .limit(1)
          .get();
    }

    if (query.docs.isEmpty) {
      throw Exception('UNTAR ID tidak ditemukan');
    }

    final penerimaDoc = query.docs.first;
    if (penerimaDoc.id == user.uid) {
      throw Exception('Tidak bisa transfer ke akun sendiri');
    }

    final data = penerimaDoc.data();
    return {
      'uid': penerimaDoc.id,
      'untarId': data['untarId']?.toString() ?? tujuanId,
      'nama': data['nama'] ?? data['username'] ?? 'Pengguna UNTAR',
    };
  }

  static Future<void> processTransfer({
    required String tujuanId,
    required int nominal,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Pengguna belum login');

    final pengirimRef = _db.collection('users').doc(user.uid);

    var query = await _db
        .collection('users')
        .where('untarId', isEqualTo: tujuanId)
        .limit(1)
        .get();

    if (query.docs.isEmpty && int.tryParse(tujuanId) != null) {
      query = await _db
          .collection('users')
          .where('untarId', isEqualTo: int.parse(tujuanId))
          .limit(1)
          .get();
    }

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

      final dataPengirim = pengirim.data() ?? {};
      final dataPenerima = penerima.data() ?? {};

      final double saldoPengirim = (dataPengirim['saldo'] ?? 0).toDouble();
      final double saldoPenerima = (dataPenerima['saldo'] ?? 0).toDouble();

      final String idPengirim = dataPengirim['untarId']?.toString() ?? '';
      final String idPenerima = dataPenerima['untarId']?.toString() ?? tujuanId;

      if (saldoPengirim < nominal) {
        throw Exception('Saldo tidak cukup');
      }

      final num newSaldoPengirim = saldoPengirim - nominal;
      final num newSaldoPenerima = saldoPenerima + nominal;

      transaction.update(pengirimRef, {
        'saldo': newSaldoPengirim == newSaldoPengirim.roundToDouble()
            ? newSaldoPengirim.toInt()
            : newSaldoPengirim,
      });

      transaction.update(penerimaRef, {
        'saldo': newSaldoPenerima == newSaldoPenerima.roundToDouble()
            ? newSaldoPenerima.toInt()
            : newSaldoPenerima,
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