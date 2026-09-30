import 'package:flutter/material.dart';
import '../dashboard/screens/dashboard_screen.dart';
import 'buka_rekening.dart';

class LoginRekening extends StatefulWidget {
  const LoginRekening({super.key});

  @override
  State<LoginRekening> createState() => _LoginRekeningState();
}

class _LoginRekeningState extends State<LoginRekening> {
  final untarIdC = TextEditingController();
  final passC = TextEditingController();

  String pesan = '';

  void masuk() {
    String untarId = untarIdC.text;
    String pass = passC.text;

    if (untarId == '' || pass == '') {
      setState(() {
        pesan = 'UNTAR ID dan password harus diisi';
      });
      return;
    }

    if (akunUntarId == '') {
      setState(() {
        pesan = 'Akun belum terdaftar, silakan buka rekening dulu';
      });
      return;
    }

    if (untarId != akunUntarId || pass != akunPassword) {
      setState(() {
        pesan = 'UNTAR ID atau password salah';
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: untarIdC,
                decoration: const InputDecoration(
                  labelText: 'UNTAR ID',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                pesan,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: masuk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF880C04),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Masuk"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}