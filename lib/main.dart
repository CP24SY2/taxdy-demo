import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? selectedMedia;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
          final media = await ImagePicker().pickImage(source: ImageSource.gallery);
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
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("Select image"),
      );
    }
    return Center (
      child: Image.file(selectedMedia!,
      width: 200,),
    );
  }

  Widget _extractTextView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("No Result"),
      );
    }
    return FutureBuilder(future: _extractText(selectedMedia!), builder: (context, snapshot) {
      return Text(snapshot.data ?? "",
      style: const TextStyle(
        fontSize: 50
      ),);
    });
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final InputImage inputimage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputimage);
    String text = recognizedText.text;
    LineSplitter ls = new LineSplitter();
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
