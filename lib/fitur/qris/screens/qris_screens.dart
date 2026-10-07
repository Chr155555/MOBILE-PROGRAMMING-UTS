import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'scan_screens.dart';
import '../widgets/qris_app.dart';
import '../widgets/qris_codecard.dart';
import '../widgets/qris_scanbutton.dart';

class Qris extends StatelessWidget {
  const Qris({super.key});

  String get myQrData {
    final user = FirebaseAuth.instance.currentUser;

    return jsonEncode({
      'type': 'qris',
      'uid': user?.uid ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: QrisAppBar(
        onBack: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/wallpaper.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Header seperti di mutasi — langsung di atas wallpaper
                  const Text(
                    'Pembayaran QRIS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Silahkan scan untuk melakukan pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Card putih berisi konten QRIS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrisScanButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QrisScan(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 24, thickness: 1.5),
                        const Text(
                          "QR Saya",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        QrisCodeCard(data: myQrData),
                        const SizedBox(height: 15),
                        const Text(
                          "Tunjukkan QR ini kepada pengguna lain",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}