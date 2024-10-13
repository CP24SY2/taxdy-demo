import 'package:flutter/material.dart';
import 'package:taxdy_demo/screens/home.dart';

void main() => runApp(TaxdyApp());

class TaxdyApp extends StatelessWidget {
  const TaxdyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Taxdy Demo",
      home: Scaffold(
        body: Homepage(),
      ),
    );
  }
}
