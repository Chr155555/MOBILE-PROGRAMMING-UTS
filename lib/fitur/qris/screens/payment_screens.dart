import 'package:flutter/material.dart';
import '../model/qris_service.dart';
import '../widgets/qris_amount.dart';
import '../widgets/qris_paymentbutton.dart';
import 'qris_success_screens.dart';

class QrisPayment extends StatefulWidget {
  final String penerimaUid;
  final String accountId;
  final String recipientName;

  const QrisPayment({
    super.key,
    required this.penerimaUid,
    required this.accountId,
    required this.recipientName,
  });

  @override
  State<QrisPayment> createState() => _QrisPaymentState();
}

class _QrisPaymentState extends State<QrisPayment> {
  static const Color untarRed = Color(0xFF880C04);

  final TextEditingController amountController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final String raw = amountController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final int? amount = int.tryParse(raw);

    if (amount == null || amount <= 0) {
      _showError('Masukkan nominal pembayaran');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await QrisService.processPayment(
        penerimaUid: widget.penerimaUid,
        nominal: amount,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QrisSuccess(
            recipientName: widget.recipientName,
            amount: amount.toDouble(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran'),
        backgroundColor: untarRed,
        foregroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle_sharp,
                      size: 67,
                      color: untarRed,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.recipientName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'ID: ${widget.accountId}',
                      style: const TextStyle(color: Colors.black54,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              QrisAmount(controller: amountController,),
              const Spacer(),
              QrisPaymentButton(onPressed: _pay, isLoading: isLoading,),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}