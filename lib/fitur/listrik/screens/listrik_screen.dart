import 'package:flutter/material.dart';

import '../widgets/listrik_pin_keypad.dart';
import 'listrik_nominal_screen.dart';

const Color untarRed = Color(0xFF880C04);

class ListrikScreen extends StatefulWidget {
  const ListrikScreen({super.key});

  @override
  State<ListrikScreen> createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  String _nomorMeter = "";
  String _errorMessage = "";

  void _onNumberTap(String value) {
    if (_nomorMeter.length < 12) {
      setState(() {
        _nomorMeter += value;
        _errorMessage = "";
      });
    }
  }

  void _onDeleteTap() {
    if (_nomorMeter.isNotEmpty) {
      setState(() {
        _nomorMeter = _nomorMeter.substring(0, _nomorMeter.length - 1);
        _errorMessage = "";
      });
    }
  }

  void _proceedToNominal() {
    if (_nomorMeter.length < 11 || _nomorMeter.length > 12) {
      setState(() {
        _errorMessage = 'Nomor meter harus 11 atau 12 digit';
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListrikNominalScreen(nomorMeter: _nomorMeter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidLength =
        _nomorMeter.length >= 11 && _nomorMeter.length <= 12;

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
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.electric_meter, color: untarRed),
                          SizedBox(width: 10),
                          Text(
                            'Nomor Meter PLN',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _nomorMeter.isEmpty
                            ? 'Masukkan 11-12 digit'
                            : _nomorMeter,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _nomorMeter.isEmpty
                              ? Colors.black26
                              : Colors.black87,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                ListrikPinKeypad(
                  untarRed: untarRed,
                  onNumberTap: _onNumberTap,
                  onDeleteTap: _onDeleteTap,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValidLength
                          ? untarRed
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: isValidLength ? 4 : 0,
                    ),
                    onPressed: isValidLength ? _proceedToNominal : null,
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
