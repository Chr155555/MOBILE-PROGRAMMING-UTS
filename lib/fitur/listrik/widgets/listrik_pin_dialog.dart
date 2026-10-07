import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListrikPinDialog extends StatefulWidget {
  const ListrikPinDialog({super.key});

  @override
  State<ListrikPinDialog> createState() => _ListrikPinDialogState();
}

class _ListrikPinDialogState extends State<ListrikPinDialog> {
  static const Color untarRed = Color(0xFF880C04);

  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    final enteredPin = _pinController.text.trim();
    if (enteredPin.isEmpty || enteredPin.length != 6) {
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
      if (user == null) {
        setState(() {
          _errorMessage = 'Pengguna belum login';
          _isLoading = false;
        });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        setState(() {
          _errorMessage = 'Data pengguna tidak ditemukan';
          _isLoading = false;
        });
        return;
      }

      final savedPin = doc.data()?['pin'] ?? '';

      if (enteredPin == savedPin) {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _errorMessage = 'PIN salah, coba lagi';
          _isLoading = false;
          _pinController.clear();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan, coba lagi';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Column(
        children: [
          Icon(Icons.lock_outline, color: untarRed, size: 40),
          SizedBox(height: 8),
          Text(
            'Masukkan PIN',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 4),
          Text(
            'Masukkan PIN 6 digit untuk konfirmasi pembayaran',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            autofocus: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintStyle: const TextStyle(
                letterSpacing: 4,
                color: Colors.black26,
                fontSize: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: untarRed, width: 2),
              ),
              errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
            ),
            onSubmitted: (_) => _verifyPin(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Batal', style: TextStyle(color: Colors.black54)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyPin,
          style: ElevatedButton.styleFrom(
            backgroundColor: untarRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Konfirmasi'),
        ),
      ],
    );
  }
}
