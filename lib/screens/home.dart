import 'package:flutter/material.dart';
import 'package:taxdy_demo/screens/scanner.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 0),
          Column(
            children: [
              Text(
                'Tax-dy',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Demo',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScannerPage()),
              );
            },
            child: Text(
              'Scanner',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
