import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../qris/widgets/qris_app.dart';
import '../model/transfer_service.dart';
import '../widgets/transfer_pin_keypad.dart';
import '../widgets/transfer_button.dart';

const Color untarRed = Color(0xFF880C04);

class TransferPinScreen extends StatefulWidget {
  final String tujuanId;
  final String namaPenerima;
  final int nominal;
  final String formattedAmount;

  const TransferPinScreen({
    super.key,
    required this.tujuanId,
    required this.namaPenerima,
    required this.nominal,
    required this.formattedAmount,
  });

  @override
  State<TransferPinScreen> createState() => _TransferPinScreenState();
}

class _TransferPinScreenState extends State<TransferPinScreen> {
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
        _verifyPinAndTransfer();
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

  Future<void> _verifyPinAndTransfer() async {
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

      await TransferService.processTransfer(
        tujuanId: widget.tujuanId,
        nominal: widget.nominal,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer Rp ${widget.formattedAmount} berhasil!')),
      );

      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);

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
      appBar: QrisAppBar(
        onBack: () => Navigator.pop(context),
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
                      const Icon(
                        Icons.lock_outline,
                        color: untarRed,
                        size: 40,
                      ),
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
                        'Transfer ke ${widget.namaPenerima} (Rp ${widget.formattedAmount})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Indikator 6 Digit PIN
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
                                color: isFilled ? untarRed : Colors.grey.shade400,
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

                TransferPinKeypad(
                  untarRed: untarRed,
                  onNumberTap: _onNumberTap,
                  onDeleteTap: _onDeleteTap,
                ),

                const SizedBox(height: 14),

                TransferButton(
                  isEnabled: _pin.length == 6,
                  isLoading: _isLoading,
                  untarRed: untarRed,
                  onPressed: _verifyPinAndTransfer,
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