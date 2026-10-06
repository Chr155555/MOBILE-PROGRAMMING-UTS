import 'package:flutter/material.dart';

class TransferAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color untarRed;

  const TransferAppBar({
    super.key,
    this.untarRed = const Color(0xFF880C04),
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
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
              Text(
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 151, 0, 0),
            ),
            label: const Text("Kembali"),
          ),
        ],
      ),
    );
  }
}