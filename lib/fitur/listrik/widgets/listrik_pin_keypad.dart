import 'package:flutter/material.dart';

class ListrikPinKeypad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onDeleteTap;
  final Color untarRed;

  const ListrikPinKeypad({
    super.key,
    required this.onNumberTap,
    required this.onDeleteTap,
    this.untarRed = const Color(0xFF880C04),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildKeypadBtn("1", () => onNumberTap("1")),
              _buildKeypadBtn("2", () => onNumberTap("2")),
              _buildKeypadBtn("3", () => onNumberTap("3")),
            ],
          ),
          Row(
            children: [
              _buildKeypadBtn("4", () => onNumberTap("4")),
              _buildKeypadBtn("5", () => onNumberTap("5")),
              _buildKeypadBtn("6", () => onNumberTap("6")),
            ],
          ),
          Row(
            children: [
              _buildKeypadBtn("7", () => onNumberTap("7")),
              _buildKeypadBtn("8", () => onNumberTap("8")),
              _buildKeypadBtn("9", () => onNumberTap("9")),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox(height: 52)),
              _buildKeypadBtn("0", () => onNumberTap("0")),
              _buildKeypadIconBtn(Icons.backspace_outlined, onDeleteTap),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadBtn(
    String label,
    VoidCallback onTap, {
    double fontSize = 24,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: untarRed.withValues(alpha: 0.15),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadIconBtn(IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.red.withValues(alpha: 0.15),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: untarRed),
            ),
          ),
        ),
      ),
    );
  }
}
