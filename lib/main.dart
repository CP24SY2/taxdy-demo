import 'package:flutter/material.dart';
import 'package:taxdy_demo/screens/home.dart';

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
              // title: const Text('Tax-dy',
              //     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              // backgroundColor: Colors.orangeAccent,
              ),
          body: const Homepage()),
    );
  }
}
