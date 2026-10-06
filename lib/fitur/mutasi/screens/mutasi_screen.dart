import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/mutasi_model.dart';
import '../widgets/mutasi_widgets.dart';

class MutasiScreen extends StatelessWidget {
  const MutasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User ? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  'my',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'UNTAR',
                  style: TextStyle(
                    fontSize: 24,
                    color: merahUntar,
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
                foregroundColor: merahUntar,
              ),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
      body: Container(
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
        child: user == null
            ? const Center(
                child: Text(
                  'Silakan login terlebih dahulu',
                ),
              )
            : StreamBuilder<List<MutasiItem>>(
                stream: MutasiService.streamMutasi(
                  user.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: merahUntar,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Gagal mengambil mutasi rekening',
                      ),
                    );
                  }
                  final mutasi = snapshot.data ?? [];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mutasi Rekening',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Riwayat transaksi rekening kamu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: mutasi.isEmpty
                              ? const MutasiKosong()
                              : ListView.builder(
                                  itemCount: mutasi.length,
                                  itemBuilder:
                                      (context, index) {
                                    return MutasiCard(
                                      item: mutasi[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}