import 'package:flutter/material.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text(
              "my",
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
              ),
            ),
            Text(
              "UNTAR",
              style: TextStyle(
                fontSize: 24,
                color: const Color.fromARGB(255, 136, 12, 4),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/wallpaper.jpg'),
                  fit: BoxFit.cover,
                ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}