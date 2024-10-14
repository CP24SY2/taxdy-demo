import 'package:flutter/material.dart';
import 'package:taxdy_demo/screens/api.dart';
import 'package:taxdy_demo/screens/ocr.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner', style: TextStyle(color: Color(0xFF757575))),
        centerTitle: false,
        titleSpacing: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                _buildButton(
                  context,
                  label: 'OCR',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OcrPage()),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildButton(
                  context,
                  label: 'API',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ApiPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 550),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      height: 60,
      width: 400,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
