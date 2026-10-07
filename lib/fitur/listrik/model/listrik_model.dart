import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListrikModel {
  static String formatRupiah(int value) {
    String angka = value.toString();

    return angka.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  static String generateToken() {
    final random = Random();

    return List.generate(20, (_) => random.nextInt(10)).join();
  }

  static String formatToken(String token) {
    return token
        .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ')
        .trim();
  }

  static Future<String> bayarListrik({
    required String nomorMeter,
    required int nominal,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final db = FirebaseFirestore.instance;

    final userRef = db.collection('users').doc(user.uid);

    final mutasiRef = userRef.collection('mutasi').doc();

    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('Data rekening tidak ditemukan');
      }

      final data = snapshot.data()!;

      final double saldo = (data['saldo'] ?? 0).toDouble();

      if (saldo < nominal) {
        throw Exception('Saldo tidak mencukupi');
      }

      transaction.update(userRef, {'saldo': saldo - nominal});

      transaction.set(mutasiRef, {
        'judul': 'Pembayaran Listrik',
        'keterangan': 'PLN - $nomorMeter',
        'nominal': nominal,
        'type': 'keluar',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });

    return generateToken();
  }
}
