import 'package:cloud_firestore/cloud_firestore.dart';

class AkunModel {
  final String email;
  final String untarId;
  final String telepon;

  AkunModel({
    required this.email,
    required this.untarId,
    required this.telepon,
  });

  factory AkunModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AkunModel(
      email: data['email'] ?? '-',
      untarId: data['untarId'] ?? '-',
      telepon: data['telepon'] ?? '-',
    );
  }
}