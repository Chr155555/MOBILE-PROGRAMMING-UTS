import 'package:flutter/material.dart';

import '../model/listrik_model.dart';
import '../widgets/nominal_listrik_button.dart';
import '../widgets/listrik_keypad.dart';
import '../widgets/listrik_button.dart';
import '../widgets/listrik_confirm_popup.dart';
import 'listrik_pin_screen.dart';

const Color untarRed = Color(0xFF880C04);

class ListrikNominalScreen extends StatefulWidget {
  final String nomorMeter;

  const ListrikNominalScreen({super.key, required this.nomorMeter});

  @override
  State<ListrikNominalScreen> createState() => _ListrikNominalScreenState();
}

class _ListrikNominalScreenState extends State<ListrikNominalScreen> {
  String _rawAmount = "";

  String get _formattedAmount {
    if (_rawAmount.isEmpty || _rawAmount == "0") return "0";

    return ListrikModel.formatRupiah(int.parse(_rawAmount));
  }

  void _onNumberTap(String value) {
    setState(() {
      if (_rawAmount.isEmpty && (value == "0" || value == "000")) return;
      if (_rawAmount.length + value.length <= 11) {
        _rawAmount += value;
      }
    });
  }

  void _onDeleteTap() {
    setState(() {
      if (_rawAmount.isNotEmpty) {
        _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
      }
    });
  }

  void _setPresetAmount(int value) {
    setState(() {
      _rawAmount = value.toString();
    });
  }

  Future<void> _handleNext() async {
    if (_rawAmount.isEmpty) return;

    final nominal = int.parse(_rawAmount);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ListrikConfirmPopup(
        nomorMeter: widget.nomorMeter,
        formattedAmount: _formattedAmount,
        untarRed: untarRed,
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListrikPinScreen(
          nomorMeter: widget.nomorMeter,
          nominal: nominal,
          formattedAmount: _formattedAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentNominal = int.tryParse(_rawAmount) ?? 0;

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
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: untarRed,
                        child: Icon(Icons.electric_meter, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nomor Meter PLN',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              widget.nomorMeter,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                    children: [
                      const Text(
                        'Nominal Pembelian',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Rp $_formattedAmount',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: _rawAmount.isNotEmpty
                                ? untarRed
                                : Colors.black26,
                          ),
                        ),
                      ),
                      const Divider(height: 24, thickness: 1.5),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ListrikNominalButton(
                            nominal: 20000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(20000),
                          ),
                          ListrikNominalButton(
                            nominal: 50000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(50000),
                          ),
                          ListrikNominalButton(
                            nominal: 100000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(100000),
                          ),
                          ListrikNominalButton(
                            nominal: 200000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(200000),
                          ),
                          ListrikNominalButton(
                            nominal: 500000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(500000),
                          ),
                          ListrikNominalButton(
                            nominal: 1000000,
                            nominalDipilih: currentNominal,
                            onTap: () => _setPresetAmount(1000000),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ListrikKeypad(
                  untarRed: untarRed,
                  onNumberTap: _onNumberTap,
                  onDeleteTap: _onDeleteTap,
                ),
                const SizedBox(height: 14),
                ListrikButton(
                  isEnabled: _rawAmount.isNotEmpty,
                  isLoading: false,
                  untarRed: untarRed,
                  onPressed: _handleNext,
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
