import 'package:flutter/material.dart';
import 'package:taxdy_demo/screens/ocrPage.dart';

void main() {
  runApp(const TaxdyApp());
}

class TaxdyApp extends StatelessWidget {
  const TaxdyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const OcrPage(),
    );
  }
}
