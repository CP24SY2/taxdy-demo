import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  File? selectedMedia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageView(),
            _extractTextView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final media =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (media != null) {
            final data = File(media.path);
            setState(() {
              selectedMedia = data;
            });
          }
        },
        tooltip: 'Select Image',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("Select image"),
      );
    }
    return Center(
      child: Image.file(
        selectedMedia!,
        width: 200,
      ),
    );
  }

  Widget _extractTextView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("No Result"),
      );
    }
    return FutureBuilder(
        future: _extractText(selectedMedia!),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? "",
            style: const TextStyle(fontSize: 50),
          );
        });
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final InputImage inputimage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputimage);
    String text = recognizedText.text;
    LineSplitter ls = LineSplitter();
    List<String> textList = ls.convert(text);
    for (var i = 0; i < textList.length; i++) {
      if (textList[i].contains("THB")) {
        log("text: $textList[i]");
        text = textList[i];
        textRecognizer.close();
        return text;
      }
    }
    textRecognizer.close();

    return text;
  }
}
