import 'package:flutter/material.dart';
import '../dashboard/model/dashboard_model.dart';
import '../dashboard/screens/dashboard_screen.dart';

class QrisSuccess extends StatelessWidget {
  final String recipientName;
  final double amount;

  const QrisSuccess({
    super.key,
    required this.recipientName,
    required this.amount,
  });

  static const Color untarRed = Color(0xFF880C04);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/wallpaper.jpg',fit: BoxFit.cover,),
          ),

          SafeArea(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("my", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.red),),
                          const Text("UNTAR", style: TextStyle(fontSize: 24, color: untarRed, fontStyle:FontStyle.italic, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),),],
                    ),

                    child: Column(mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 85, height: 85,
                          decoration:BoxDecoration(color: Colors.green.withValues(alpha: 0.12,),shape: BoxShape.circle,),
                          child: 
                          const Icon(Icons.check, size: 50, color: Colors.green,),
                        ),

                        const SizedBox(height: 20),

                        const Text('Pembayaran Berhasil',
                          textAlign:TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          formatRupiah(amount),
                          style: const TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold,
                            color: untarRed,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text( 'Pembayaran kepada ''$recipientName berhasil.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                 MaterialPageRoute(builder:(context) => const Dashboard(),),
                                (route) => false,
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:untarRed,
                              foregroundColor:Colors.white,
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                            child: 
                            const Text('Kembali ke Dashboard',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}