import 'package:flutter/material.dart';

class QrisAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QrisAppBar({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  static const Color untarRed = Color(0xFF880C04);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                "my",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
              const Text(
                "UNTAR",
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
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: untarRed,
            ),
            label: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}