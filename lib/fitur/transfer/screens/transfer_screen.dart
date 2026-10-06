import 'package:flutter/material.dart';
import '../model/transfer_service.dart';
import '../widgets/transfer_app_bar.dart';
import '../widgets/transfer_target_input.dart';
import '../widgets/transfer_amount_card.dart';
import '../widgets/transfer_keypad.dart';
import '../widgets/transfer_button.dart';

const Color untarRed = Color(0xFF880C04);

// Alias agar pemanggilan nama lama `transfer()` tetap berfungsi
// ignore: camel_case_types
typedef transfer = TransferScreen;

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String _rawAmount = "";
  final TextEditingController _untarIdController = TextEditingController();
  bool _loading = false;

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
    final tujuan = _untarIdController.text.trim();

    if (tujuan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UNTAR ID tujuan harus diisi')),
      );
      return;
    }

    if (_rawAmount.isEmpty) return;

    final nominal = int.parse(_rawAmount);

    setState(() {
      _loading = true;
    });

    try {
      await TransferService.processTransfer(
        tujuanId: tujuan,
        nominal: nominal,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer Rp $_formattedAmount berhasil')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _untarIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TransferAppBar(untarRed: untarRed),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/wallpaper.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TransferTargetInput(
                    controller: _untarIdController,
                  ),
                  const SizedBox(height: 10),
                  TransferAmountCard(
                    formattedAmount: _formattedAmount,
                    hasAmount: _rawAmount.isNotEmpty,
                    untarRed: untarRed,
                    onPresetTap: _setPresetAmount,
                  ),
                  const Spacer(),
                  TransferKeypad(
                    untarRed: untarRed,
                    onNumberTap: _onNumberTap,
                    onDeleteTap: _onDeleteTap,
                  ),
                  const SizedBox(height: 14),
                  TransferButton(
                    isEnabled: _rawAmount.isNotEmpty,
                    isLoading: _loading,
                    untarRed: untarRed,
                    onPressed: _handleTransfer,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}