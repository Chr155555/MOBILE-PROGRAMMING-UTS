
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/rekening_model.dart';
import '../widgets/rekening_widget.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class LoginRekening extends StatefulWidget {
  const LoginRekening({super.key});

  @override
  State<LoginRekening> createState() => _LoginRekeningState();
}

class _LoginRekeningState extends State<LoginRekening> {
  final emailUser = TextEditingController();
  final passUser = TextEditingController();

  String pesan = '';
  bool loading = false;

  Future<void> login() async {
    String email = emailUser.text.trim();
    String pass = passUser.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        pesan = 'Semua kolom harus diisi';
      });
      return;
    }

    setState(() {
      loading = true;
      pesan = '';
    });

    try {
      await RekeningModel.masuk(
        email: email,
        password: pass,
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
        if (e.code == 'invalid-email') {
          pesan = 'Format email tidak valid';
        } else if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          pesan = 'Email atau password salah';
        } else if (e.code == 'too-many-requests') {
          pesan = 'Terlalu banyak percobaan login';
        } else {
          pesan = 'Gagal login: ${e.message}';
        }
      });
    } catch (e) {
      if (!mounted) return;

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
    passUser.dispose();
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
                controller: passUser,
                label: 'Password',
                obscureText: true,
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
                judul: 'Masuk',
                onPressed: login,
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
