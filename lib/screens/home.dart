import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 150),
          const Text(
            '5,000 BAHT',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Add OCR
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text(
                  'OCR',
                  style: TextStyle(fontSize: 32, color: Colors.red),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Add API
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                child: const Text(
                  'API',
                  style: TextStyle(fontSize: 32, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
