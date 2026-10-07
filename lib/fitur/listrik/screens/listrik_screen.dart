import 'package:flutter/material.dart';

import '../model/listrik_model.dart';
import '../widgets/listrik_widget.dart';

class ListrikScreen extends StatefulWidget {
  const ListrikScreen({super.key});

  @override
  State<ListrikScreen> createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  final TextEditingController meterController = TextEditingController();

  int nominal = 0;
  bool loading = false;

  Future<void> bayar() async {
    final nomorMeter = meterController.text.trim();

    if (nomorMeter.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nomor meter harus diisi')));
      return;
    }

    if (nominal == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih nominal listrik')));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final token = await ListrikModel.bayarListrik(
        nomorMeter: nomorMeter,
        nominal: nominal,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TokenDialog(
            nomorMeter: nomorMeter,
            nominal: nominal,
            token: token,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/wallpaper.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pembayaran Listrik',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: meterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Meter',
                        hintText: 'Masukkan nomor meter',
                        prefixIcon: Icon(Icons.electric_meter),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pilih Nominal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        NominalListrikButton(
                          nominal: 20000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 20000;
                            });
                          },
                        ),
                        NominalListrikButton(
                          nominal: 50000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 50000;
                            });
                          },
                        ),
                        NominalListrikButton(
                          nominal: 100000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 100000;
                            });
                          },
                        ),
                        NominalListrikButton(
                          nominal: 200000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 200000;
                            });
                          },
                        ),
                        NominalListrikButton(
                          nominal: 500000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 500000;
                            });
                          },
                        ),
                        NominalListrikButton(
                          nominal: 1000000,
                          nominalDipilih: nominal,
                          onTap: () {
                            setState(() {
                              nominal = 1000000;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Text(
                        nominal == 0
                            ? 'Rp 0'
                            : 'Rp ${ListrikModel.formatRupiah(nominal)}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: untarRed,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : bayar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: untarRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Bayar Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
