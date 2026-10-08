import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'fitur/rekening/screens/pilih_rekening.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("my", style: TextStyle(fontSize: 24, color: Colors.red)),
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
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Selamat datang,", style: TextStyle(fontSize: 20)),
                        const Text(
                          "Pengguna myUNTAR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PilihRekening(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(255, 151, 0, 0),
                            minimumSize: const Size(250, 45),
                          ),
                          child: const Text("Masuk"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.headset_mic_rounded,
                          size: 16,
                          color: Color.fromARGB(255, 136, 12, 4),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "UNTAR Helper: 535250130",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 136, 12, 4),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Layanan Bantuan Customer Service 24 Jam",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}