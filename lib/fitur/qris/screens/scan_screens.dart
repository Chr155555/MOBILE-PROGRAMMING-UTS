import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../model/qris_service.dart';
import 'payment_screens.dart';

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

  Future<void> _processQr(String rawData) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final Map<String, dynamic> data = jsonDecode(rawData);

      if (data['type'] != 'qris') {
        throw Exception('Salah QR');
      }

      final String penerimaUid =
          data['uid']?.toString() ?? '';

      if (penerimaUid.isEmpty) {
        throw Exception('UID tidak ditemukan');
      }

      final penerima =
          await QrisService.getPenerima(penerimaUid);

      final dataPenerima = penerima.data();

      if (dataPenerima == null) {
        throw Exception('Data penerima tidak ditemukan');
      }

      final String recipientName =
          dataPenerima['untarId']?.toString() ?? 'Tidak diketahui';

      final String accountId =
          dataPenerima['untarId']?.toString() ?? '-';

      await controller.stop();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrisPayment(
            penerimaUid: penerimaUid,
            accountId: accountId,
            recipientName: recipientName,
          ),
        ),
      );

      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        await controller.start();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
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
            child: Container(width: 280,height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4,),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(left: 20, right: 20, bottom: 30, 
          child: Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Arahkan kamera ke QR code',
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