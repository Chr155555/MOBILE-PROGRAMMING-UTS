import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'qris_scan.dart';
import 'dart:convert';

class Qris extends StatelessWidget {
  const Qris({super.key});

  static const Color untarRed = Color(0xFF880C04);

String get myQrData {
  return jsonEncode({
    'type': 'qris',
    'accountId': '676767676767',
    'name': 'WARUNK UNTAR',
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "my",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  "UNTAR",
                  style: TextStyle(
                    fontSize: 24,
                    color: untarRed,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor:
                    const Color.fromARGB(255, 151, 0, 0),
              ),
              label: const Text("Kembali"),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/wallpaper.jpg', fit: BoxFit.cover,),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 55,
                      vertical: 19,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Pembayaran QRIS",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Silahkan scan untuk melakukan pembayaran",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => const QrisScan(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_scanner,),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: untarRed,
                              foregroundColor:Colors.white,
                              shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            label: const Text("Scan QR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 24,thickness: 1.5,),

                        const Text("QR Saya",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Container(
                          padding:const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(15,),
                            border: Border.all(color:Colors.grey.shade300,),
                          ),

                          child: QrImageView(data: myQrData,size: 220,),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Tunjukkan QR ini kepada pengguna lain",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
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