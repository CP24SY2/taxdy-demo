import 'package:flutter/material.dart';

void main() {
  runApp(const TaxdyApp());
}

class TaxdyApp extends StatelessWidget {
  const TaxdyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tax-dy',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 150),
              const Text(
                '1,000 BAHT',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add OCR
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'OCR',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add API
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'API',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
