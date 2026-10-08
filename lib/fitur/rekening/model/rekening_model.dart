
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RekeningModel {
  static Future<void> daftar({
    required String email,
    required String untarId,
    required String password,
    required String telepon,
    required String pin,
  }) async {
    final cekUntarId = await FirebaseFirestore.instance
        .collection('users')
        .where('untarId', isEqualTo: untarId)
        .limit(1)
        .get();

    if (cekUntarId.docs.isNotEmpty) {
      throw Exception('UNTAR ID sudah terdaftar');
    }

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'email': email,
      'untarId': untarId,
      'telepon': telepon,
      'saldo': 2500000,
      'pin': pin,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> masuk({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
