
import 'package:flutter/material.dart';
import 'buka_rekening.dart';
import 'login_rekening.dart';

class PilihRekening extends StatelessWidget {
  const PilihRekening({super.key});

  static const Color untarRed = Color(0xFF880C04);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  "my",
                  style: TextStyle(fontSize: 24, color: Colors.red),
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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 151, 0, 0),
              ),
              label: const Text("Kembali"),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/wallpaper.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BukaRekening(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: untarRed,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Buka Rekening",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginRekening(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: untarRed,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Sudah Punya Rekening",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
