import 'package:flutter/material.dart';
import '../../qris/widgets/qris_app.dart';
import '../model/transfer_service.dart';
import '../widgets/transfer_target_input.dart';
import '../widgets/transfer_button.dart';
import 'transfer_amount_screen.dart';

const Color untarRed = Color(0xFF880C04);

// ignore: camel_case_types
typedef transfer = TransferScreen;

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _untarIdController = TextEditingController();
  bool _loading = false;

  Future<void> _checkAndProceed() async {
    final tujuan = _untarIdController.text.trim();

    if (tujuan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UNTAR ID tujuan harus diisi')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final penerimaData = await TransferService.checkRecipient(tujuan);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferAmountScreen(
            tujuanId: penerimaData['untarId'],
            namaPenerima: penerimaData['nama'],
          ),
        ),
      );
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  const SizedBox(height: 20),
                  TransferTargetInput(
                    controller: _untarIdController,
                  ),
                  const Spacer(),
                  TransferButton(
                    isEnabled: true,
                    isLoading: _loading,
                    untarRed: untarRed,
                    onPressed: _checkAndProceed,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}