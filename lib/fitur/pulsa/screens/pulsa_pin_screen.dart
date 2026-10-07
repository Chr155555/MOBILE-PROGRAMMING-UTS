import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/fitur/pulsa/widgets/pulsa_isi_dialog.dart';

import '../../dashboard/screens/dashboard_screen.dart';
import '../model/pulsa_model.dart';
import '../widgets/pulsa_pin_keypad.dart';
import '../widgets/pulsa_button.dart';

const Color untarRed = Color(0xFF880C04);

class PulsaPinScreen extends StatefulWidget {
  final String nomorHp;
  final int nominal;
  final String formattedAmount;

  const PulsaPinScreen({
    super.key,
    required this.nomorHp,
    required this.nominal,
    required this.formattedAmount,
  });

  @override
  State<PulsaPinScreen> createState() => _PulsaPinScreenState();
}

class _PulsaPinScreenState extends State<PulsaPinScreen> {
  String _pin = "";
  bool _isLoading = false;
  String _errorMessage = "";

  void _onNumberTap(String value) {
    if (_pin.length < 6) {
      setState(() {
        _pin += value;
        _errorMessage = "";
      });
      if (_pin.length == 6) {
        _verifyPinAndPay();
      }
    }
  }

  void _onDeleteTap() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = "";
      });
    }
  }

  Future<void> _verifyPinAndPay() async {
    if (_pin.length != 6) {
      setState(() {
        _errorMessage = 'PIN harus 6 digit';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Pengguna belum login');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final savedPin = doc.data()?['pin'] ?? '';

      if (_pin != savedPin) {
        setState(() {
          _errorMessage = 'PIN salah, coba lagi';
          _isLoading = false;
          _pin = '';
        });
        return;
      }

      await PulsaModel.beliPulsa(
        nomorHp: widget.nomorHp,
        nominal: widget.nominal,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PulsaIsiDialog(
            nomorHp: widget.nomorHp,
            nominal: widget.nominal,
          );
        },
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
        _pin = '';
      });
    }
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
                Text('my', style: TextStyle(fontSize: 24, color: Colors.red)),
                Text(
                  'UNTAR',
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
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: untarRed,
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
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                      const Icon(Icons.lock_outline, color: untarRed, size: 40),
                      const SizedBox(height: 10),
                      const Text(
                        'Masukkan PIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pembelian Pulsa ${widget.nomorHp}\n(Rp ${widget.formattedAmount})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final isFilled = index < _pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? untarRed : Colors.transparent,
                              border: Border.all(
                                color: isFilled
                                    ? untarRed
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                PulsaPinKeypad(
                  untarRed: untarRed,
                  onNumberTap: _onNumberTap,
                  onDeleteTap: _onDeleteTap,
                ),
                const SizedBox(height: 14),
                PulsaButton(
                  isEnabled: _pin.length == 6,
                  isLoading: _isLoading,
                  untarRed: untarRed,
                  onPressed: _verifyPinAndPay,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
