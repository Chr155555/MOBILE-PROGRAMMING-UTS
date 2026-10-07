import 'package:flutter/material.dart';

import '../widgets/pulsa_pin_keypad.dart';
import 'pulsa_nominal_screen.dart';

const Color untarRed = Color(0xFF880C04);

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({super.key});

  @override
  State<PulsaScreen> createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  String _rawNumber = "";
  String _errorMessage = "";

  void _onNumberTap(String value) {
    if (_rawNumber.length < 11) {
      setState(() {
        _rawNumber += value;
        _errorMessage = "";
      });
    }
  }

  void _onDeleteTap() {
    if (_rawNumber.isNotEmpty) {
      setState(() {
        _rawNumber = _rawNumber.substring(0, _rawNumber.length - 1);
        _errorMessage = "";
      });
    }
  }

  void _proceedToNominal() {
    if (_rawNumber.length != 11) {
      setState(() {
        _errorMessage = 'Nomor HP harus 11 digit';
      });
      return;
    }

    final formattedPhone = '+62$_rawNumber';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PulsaNominalScreen(nomorHp: formattedPhone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidLength = _rawNumber.length == 11;

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
                          Icon(Icons.phone_android, color: untarRed),
                          SizedBox(width: 10),
                          Text(
                            'Nomor Telepon',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            '+62 ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: untarRed,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _rawNumber.isEmpty ? '###########' : _rawNumber,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _rawNumber.isEmpty
                                    ? Colors.black26
                                    : Colors.black87,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
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
                PulsaPinKeypad(
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
