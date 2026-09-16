import 'package:flutter/material.dart';
import 'package:flutter_application_1/transfer.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text("my", style: TextStyle(fontSize: 24, color: Colors.red)),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const transfer(),
                        ),
                      );
                    },
                    icon: Icon(Icons.money),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 151, 0, 0),
                    ),
                    label: Text("Transfer"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
