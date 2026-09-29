import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qris_payment.dart';

class QrisScan extends StatefulWidget {
  const QrisScan({super.key});

  @override
  State<QrisScan> createState() => _QrisScanState();
}

class _QrisScanState extends State<QrisScan> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _processQr(String rawData) {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    try {
      final Map<String, dynamic> data = jsonDecode(rawData);
      if (data['type'] != 'qris') {
        _showError('Salah QR');
        return;
      }

      final String name = data['name']?.toString() ?? 'Tidak diketahui';
      final String accountId = data['accountId']?.toString() ?? '-';      
      controller.stop();

      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => QrisPayment(accountId: accountId, recipientName: name,),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
          controller.start();
        }
      });
    } catch (e) {
      _showError('QR tidak valid');
    }
  }

  void _showError(String message) {
    setState(() {
      isProcessing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR'),
        backgroundColor: const Color(0xFF880C04),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final String? rawData = barcode.rawValue;
                if (rawData != null && rawData.isNotEmpty) {
                  _processQr(rawData);
                  break;
                }
              }
            },
          ),
          Center(
            child: Container(width: 280, height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4,),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(left: 20, right: 20, bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Text('Arahkan kamera ke QR code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}