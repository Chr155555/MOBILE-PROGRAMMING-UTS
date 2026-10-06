import 'package:flutter/material.dart';

class TransferAmountCard extends StatelessWidget {
  final String formattedAmount;
  final bool hasAmount;
  final Color untarRed;
  final Function(int) onPresetTap;

  const TransferAmountCard({
    super.key,
    required this.formattedAmount,
    required this.hasAmount,
    this.untarRed = const Color(0xFF880C04),
    required this.onPresetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Nominal Transfer",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Rp $formattedAmount",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: hasAmount ? untarRed : Colors.black26,
              ),
            ),
          ),
          const Divider(
            height: 24,
            thickness: 1.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPresetChip("50.000", () => onPresetTap(50000)),
              _buildPresetChip("100.000", () => onPresetTap(100000)),
              _buildPresetChip("200.000", () => onPresetTap(200000)),
              _buildPresetChip("500.000", () => onPresetTap(500000)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}