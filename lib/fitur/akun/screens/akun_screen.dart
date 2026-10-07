import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/akun_model.dart';
import '../widgets/akun_widgets.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  "my",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "UNTAR",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 136, 12, 4),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 151, 0, 0),
              ),
              label: const Text("Kembali"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal mengambil data'),
            );
          }
          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text('Data user tidak ditemukan'),
            );
          }
          final akun = AkunModel.fromFirestore(
            snapshot.data!,
          );
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/wallpaper.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfilAkun(
                    untarId: akun.untarId,
                    email: akun.email,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.95,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ItemAkun(
                          icon: Icons.badge,
                          judul: 'UNTAR ID',
                          isi: akun.untarId,
                        ),
                        const Divider(),
                        ItemAkun(
                          icon: Icons.email,
                          judul: 'Email',
                          isi: akun.email,
                        ),
                        const Divider(),
                        ItemAkun(
                          icon: Icons.phone,
                          judul: 'Nomor Telepon',
                          isi: akun.telepon,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF880C04),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Keluar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}