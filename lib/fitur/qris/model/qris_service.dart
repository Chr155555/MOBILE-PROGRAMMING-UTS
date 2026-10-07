import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrisService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getPenerima(
    String penerimaUid,
  ) async {
    final penerimaRef = _db.collection('users').doc(penerimaUid);
    final penerima = await penerimaRef.get();

    if (!penerima.exists) {
      throw Exception('Akun penerima tidak ditemukan');
    }
    return penerima;
  }

  static Future<void> processPayment({
    required String penerimaUid,
    required int nominal,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login');
    }

    if (nominal <= 0) {
      throw Exception('Nominal pembayaran tidak valid');
    }

    final pembayarRef = _db.collection('users').doc(user.uid);
    final penerimaRef = _db.collection('users').doc(penerimaUid);

    if (user.uid == penerimaUid) {
      throw Exception('Tidak bisa membayar ke akun sendiri');
    }

    final mutasiPembayar =
        pembayarRef.collection('mutasi').doc();

    final mutasiPenerima =
        penerimaRef.collection('mutasi').doc();

    await _db.runTransaction((transaction) async {
      final pembayar = await transaction.get(pembayarRef);
      final penerima = await transaction.get(penerimaRef);

      if (!pembayar.exists || !penerima.exists) {
        throw Exception('Data rekening tidak ditemukan');
      }

      final dataPembayar = pembayar.data()!;
      final dataPenerima = penerima.data()!;

      final double saldoPembayar =
          (dataPembayar['saldo'] ?? 0).toDouble();

      final double saldoPenerima =
          (dataPenerima['saldo'] ?? 0).toDouble();

      final String idPembayar =
          dataPembayar['untarId'] ?? '';

      final String idPenerima =
          dataPenerima['untarId'] ?? '';

      if (saldoPembayar < nominal) {
        throw Exception('Saldo tidak cukup');
      }

      transaction.update(pembayarRef, {
        'saldo': saldoPembayar - nominal,
      });

      transaction.update(penerimaRef, {
        'saldo': saldoPenerima + nominal,
      });

      transaction.set(mutasiPembayar, {
        'judul': 'Pembayaran QRIS',
        'keterangan': 'Pembayaran ke $idPenerima',
        'nominal': nominal,
        'type': 'keluar',
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.set(mutasiPenerima, {
        'judul': 'Pembayaran QRIS Masuk',
        'keterangan': 'Pembayaran dari $idPembayar',
        'nominal': nominal,
        'type': 'masuk',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}