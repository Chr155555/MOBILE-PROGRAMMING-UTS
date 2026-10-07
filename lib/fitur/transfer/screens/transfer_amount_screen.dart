import 'package:flutter/material.dart';
import '../../qris/widgets/qris_app.dart';
import '../widgets/transfer_amount_card.dart';
import '../widgets/transfer_keypad.dart';
import '../widgets/transfer_button.dart';
import '../widgets/transfer_confirm_popup.dart';
import 'transfer_pin_screen.dart';

const Color untarRed = Color(0xFF880C04);

class TransferAmountScreen extends StatefulWidget {
  final String tujuanId;
  final String namaPenerima;

  const TransferAmountScreen({
    super.key,
    required this.tujuanId,
    required this.namaPenerima,
  });

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  String _rawAmount = "";

  String get _formattedAmount {
    if (_rawAmount.isEmpty || _rawAmount == "0") return "0";

    return _rawAmount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
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

  Future<void> _handleTransfer() async {
    if (_rawAmount.isEmpty) return;

    final nominal = int.parse(_rawAmount);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => TransferConfirmPopup(
        namaPenerima: widget.namaPenerima,
        tujuanId: widget.tujuanId,
        formattedAmount: _formattedAmount,
        untarRed: untarRed,
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferPinScreen(
          tujuanId: widget.tujuanId,
          namaPenerima: widget.namaPenerima,
          nominal: nominal,
          formattedAmount: _formattedAmount,
        ),
      ),
    );
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

                // Info Penerima
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
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaPenerima,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'UNTAR ID: ${widget.tujuanId}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Kartu Nominal & Preset Cepat
                TransferAmountCard(
                  formattedAmount: _formattedAmount,
                  hasAmount: _rawAmount.isNotEmpty,
                  untarRed: untarRed,
                  onPresetTap: _setPresetAmount,
                ),

                const Spacer(),

                // Keypad Angka Kustom
                TransferKeypad(
                  untarRed: untarRed,
                  onNumberTap: _onNumberTap,
                  onDeleteTap: _onDeleteTap,
                ),

                const SizedBox(height: 14),

                // Tombol Lanjutkan Transfer
                TransferButton(
                  isEnabled: _rawAmount.isNotEmpty,
                  isLoading: false,
                  untarRed: untarRed,
                  onPressed: _handleTransfer,
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