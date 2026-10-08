
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/rekening_model.dart';
import '../widgets/rekening_widget.dart';
import '../../dashboard/screens/dashboard_screen.dart';

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
      await RekeningModel.daftar(
        email: email,
        untarId: untarId,
        password: pass,
        telepon: telepon,
        pin: pin,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

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
      if (!mounted) return;

      setState(() {
        if (e.toString().contains('UNTAR ID sudah terdaftar')) {
          pesan = 'UNTAR ID sudah terdaftar';
        } else {
          pesan = 'Terjadi kesalahan';
        }
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
              InputRekening(
                controller: emailUser,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 14),

              InputRekening(
                controller: untarIdUser,
                label: 'UNTAR ID',
              ),

              const SizedBox(height: 14),

              InputRekening(
                controller: passUser,
                label: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 14),

              InputRekening(
                controller: pass2User,
                label: 'Ulangi Password',
                obscureText: true,
              ),

              const SizedBox(height: 14),

              InputRekening(
                controller: teleponUser,
                label: 'Nomor Telepon',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 14),

              InputRekening(
                controller: pinUser,
                label: 'PIN 6 Digit',
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
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

              TombolRekening(
                judul: 'Daftar',
                onPressed: daftar,
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
