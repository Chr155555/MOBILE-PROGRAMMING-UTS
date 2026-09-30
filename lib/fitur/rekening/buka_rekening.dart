import 'package:flutter/material.dart';
import '../dashboard/screens/dashboard_screen.dart';

String akunEmail = '';
String akunUntarId = '';
String akunPassword = '';
String akunTelepon = '';

class BukaRekening extends StatefulWidget {
  const BukaRekening({super.key});

  @override
  State<BukaRekening> createState() => _BukaRekeningState();
}

class _BukaRekeningState extends State<BukaRekening> {
  final emailC = TextEditingController();
  final untarIdC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();
  final teleponC = TextEditingController();

  String pesan = '';

  void daftar() {
    String email = emailC.text;
    String untarId = untarIdC.text;
    String pass = passC.text;
    String pass2 = pass2C.text;
    String telepon = teleponC.text;

    if (email == '' || untarId == '' || pass == '' || telepon == '') {
      setState(() {
        pesan = 'Semua kolom harus diisi';
      });
      return;
    }

    if (pass != pass2) {
      setState(() {
        pesan = 'Password tidak sama';
      });
      return;
    }

    akunEmail = email;
    akunUntarId = untarId;
    akunPassword = pass;
    akunTelepon = telepon;

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
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
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
              TextField(
                controller: pass2C,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ulangi Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: teleponC,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                pesan,
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
                  onPressed: daftar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF880C04),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}