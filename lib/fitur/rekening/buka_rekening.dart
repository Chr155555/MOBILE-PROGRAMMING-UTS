import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/screens/dashboard_screen.dart';

class BukaRekening extends StatefulWidget {
  const BukaRekening({super.key});

  @override
  State<BukaRekening> createState() => _BukaRekeningState();
}

class _BukaRekeningState extends State<BukaRekening> {
  final emailUser = TextEditingController();
  final untarIdUser = TextEditingController();
  final passUser = TextEditingController();
  final pass2User = TextEditingController();
  final teleponUser = TextEditingController();
  final pinUser = TextEditingController();

  String pesan = '';
  bool loading = false;

  Future<void> daftar() async {
    String email = emailUser.text.trim();
    String untarId = untarIdUser.text.trim();
    String pass = passUser.text;
    String pass2 = pass2User.text;
    String telepon = teleponUser.text.trim();
    String pin = pinUser.text.trim();

    if (email == '' ||
        untarId == '' ||
        pass == '' ||
        pass2 == '' ||
        telepon == '' ||
        pin == '') {
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

    if (pass.length < 6) {
      setState(() {
        pesan = 'Password minimal 6 karakter';
      });
      return;
    }

    if (pin.length != 6) {
      setState(() {
        pesan = 'PIN harus 6 digit';
      });
      return;
    }

    if (int.tryParse(pin) == null) {
      setState(() {
        pesan = 'PIN hanya boleh berisi angka';
      });
      return;
    }

    setState(() {
      loading = true;
      pesan = '';
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
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

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          pesan = 'Email sudah terdaftar';
        } else if (e.code == 'invalid-email') {
          pesan = 'Format email tidak valid';
        } else if (e.code == 'weak-password') {
          pesan = 'Password terlalu lemah';
        } else {
          pesan = 'Gagal membuat akun: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        pesan = 'Terjadi kesalahan';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailUser.dispose();
    untarIdUser.dispose();
    passUser.dispose();
    pass2User.dispose();
    teleponUser.dispose();
    pinUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                foregroundColor:
                    const Color.fromARGB(255, 151, 0, 0),
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
                controller: emailUser,
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
                controller: untarIdUser,
                decoration: const InputDecoration(
                  labelText: 'UNTAR ID',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passUser,
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
                controller: pass2User,
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
                controller: teleponUser,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: pinUser,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'PIN 6 Digit',
                  hintText: 'Masukkan PIN',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  counterText: '',
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
                  onPressed: loading ? null : daftar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF880C04),
                    foregroundColor: Colors.white,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}