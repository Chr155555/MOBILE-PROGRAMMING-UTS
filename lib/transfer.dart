import 'package:flutter/material.dart';

class transfer extends StatefulWidget {
  const transfer({super.key});

  @override
  State<transfer> createState() => _transferState();
}

class _transferState extends State<transfer> {
  String _rawAmount = "";

  String get _formattedAmount {
    if (_rawAmount.isEmpty || _rawAmount == "0") return "0";
    return _rawAmount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _onNumberTap(String value) {
    setState(() {
      if (_rawAmount.isEmpty && (value == "0" || value == "000")) return;
      
      if (_rawAmount.length + value.length <= 11) {
        _rawAmount += value;
      }
    });
  }

  void _onDeleteTap() {
    setState(() {
      if (_rawAmount.isNotEmpty) {
        _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
      }
    });
  }

  void _setPresetAmount(int value) {
    setState(() {
      _rawAmount = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    const untarRed = Color(0xFF880C04);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text(
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/wallpaper.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. KONTEN (Card Atas + Keypad Bawah)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            "Rp $_formattedAmount",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: _rawAmount.isEmpty ? Colors.black26 : untarRed,
                            ),
                          ),
                        ),

                        const Divider(height: 24, thickness: 1.5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPresetChip("50.000", () => _setPresetAmount(50000)),
                            _buildPresetChip("100.000", () => _setPresetAmount(100000)),
                            _buildPresetChip("200.000", () => _setPresetAmount(200000)),
                            _buildPresetChip("500.000", () => _setPresetAmount(500000)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(
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
                            _buildKeypadBtn("1", () => _onNumberTap("1")),
                            _buildKeypadBtn("2", () => _onNumberTap("2")),
                            _buildKeypadBtn("3", () => _onNumberTap("3")),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadBtn("4", () => _onNumberTap("4")),
                            _buildKeypadBtn("5", () => _onNumberTap("5")),
                            _buildKeypadBtn("6", () => _onNumberTap("6")),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadBtn("7", () => _onNumberTap("7")),
                            _buildKeypadBtn("8", () => _onNumberTap("8")),
                            _buildKeypadBtn("9", () => _onNumberTap("9")),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadBtn("000", () => _onNumberTap("000"), fontSize: 18),
                            _buildKeypadBtn("0", () => _onNumberTap("0")),
                            _buildKeypadIconBtn(Icons.backspace_outlined, _onDeleteTap),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _rawAmount.isEmpty ? Colors.grey.shade400 : untarRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _rawAmount.isEmpty ? 0 : 4,
                      ),
                      onPressed: _rawAmount.isEmpty
                          ? null
                          : () {
                              int finalAmount = int.parse(_rawAmount);
                              print("Nominal transfer: $finalAmount");
                            },
                      child: const Text(
                        'Lanjutkan Transfer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadBtn(String label, VoidCallback onTap, {double fontSize = 24}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: const Color(0xFF880C04).withOpacity(0.15),
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
            splashColor: Colors.red.withOpacity(0.15),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: const Color(0xFF880C04)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
    );
  }
}