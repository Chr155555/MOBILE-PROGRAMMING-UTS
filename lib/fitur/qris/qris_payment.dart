import 'package:flutter/material.dart';
import '../dashboard/model/dashboard_model.dart';
import 'qris_success.dart';

class QrisPayment extends StatefulWidget {
  final String accountId;
  final String recipientName;

  const QrisPayment({
    super.key,
    required this.accountId,
    required this.recipientName,
  });

  @override
  State<QrisPayment> createState() => _QrisPaymentState();
}

class _QrisPaymentState extends State<QrisPayment> {
  static const Color untarRed = Color(0xFF880C04);
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _pay() {
    final String raw = amountController.text.replaceAll(RegExp(r'[^0-9]'),'',);
    final double? amount = double.tryParse(raw);

    if (amount == null || amount <= 0) {
      _showError('Masukkan nominal pembayaran');
      return;
    }
    if (amount > balanceNotifier.value) {
      _showError('Saldo tidak mencukupi');
      return;
    }

    setState(() {
      isLoading = true;
    });
    addTransaction(
      TransactionItem(
        title: 'Pembayaran qris',
        subtitle: widget.recipientName,
        amount: amount,
        date: DateTime.now(),
        icon: Icons.qr_code_2,
        type: TransactionType.expense,
      ),
    );

    Navigator.pushReplacement(context,
      MaterialPageRoute(
        builder: (context) => QrisSuccess(recipientName: widget.recipientName, amount: amount,),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
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

      body: Container(width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg',),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    const Icon(Icons.account_circle_sharp, size: 67, color: untarRed,),
                    const SizedBox(height: 10),
                    const SizedBox(height: 5),
                    Text(widget.recipientName, 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
                    ),

                    const SizedBox(height: 5),

                    Text('ID: ${widget.accountId}',
                      style: const TextStyle(color: Colors.black54,),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nominal Pembayaran',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                    ),

                    const SizedBox(height: 10),

                    TextField(controller:amountController,
                      keyboardType:TextInputType.number,
                      decoration:InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12,),
                          ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed:isLoading ? null : _pay,
                  style:ElevatedButton.styleFrom(
                    backgroundColor: untarRed,
                    foregroundColor: Colors.white,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : const Text('Bayar Sekarang',
                          style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold,),
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}