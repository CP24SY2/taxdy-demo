import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  String extractedText = '';
  final ImagePicker _picker = ImagePicker();
  File? selectedMedia;

  // กำหนด URL ของ API และ API Key
  final String apiUrl = 'https://api.slipok.com/api/line/apikey/31502';
  final String apiKey = 'SLIPOKUF6RYLZ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API', style: TextStyle(color: Color(0xFF757575))),
        centerTitle: false,
        titleSpacing: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _imageView(),
            SizedBox(height: 20),
            Text(
              'Extracted Data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(extractedText.isNotEmpty
                ? extractedText
                : 'No data extracted yet.'),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    // Pick an image from the gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // Check if an image was selected
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String result = await _uploadSlip(imageFile);

      setState(() {
        selectedMedia = imageFile; // Save the selected media
        extractedText = result; // Save the extracted text
      });
    }
  }

  Future<String> _uploadSlip(File image) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    // ใส่ Header
    request.headers['x-authorization'] = apiKey;

    // ใส่ไฟล์ภาพใน Body (ฟิลด์ 'files')
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      image.path,
      filename: basename(image.path),
    ));

    // Optional: คุณสามารถเพิ่มฟิลด์อื่นๆ ลงใน Body ได้ เช่น amount หรือ log
    // request.fields['log'] = 'false';

    // ส่งคำขอไปยัง SlipOk API
    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      String transDate;
      String transTime;
      String transTimestamp;
      String senderDisplayName;
      String senderName;
      String receiverDisplayName;
      String receiverName;
      String amount;

      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody.body);

        log('data: $data');

        // ดึงข้อมูลที่ต้องการจาก response
        transDate = data['data']['transDate'] ?? '';
        transTime = data['data']['transTime'] ?? '';
        transTimestamp = data['data']['transTimestamp'] ?? '';
        senderDisplayName = data['data']['sender']['displayName'] ?? '';
        senderName = data['data']['sender']['name'] ?? '';
        receiverDisplayName = data['data']['receiver']['displayName'] ?? '';
        receiverName = data['data']['receiver']['name'] ?? '';
        amount = data['data']['amount'].toString() ?? '';

        // แสดงผลข้อมูลที่ต้องการ
        return '''
        Transaction Date: $transDate
        Transaction Time: $transTime
        Transaction Timestamp: $transTimestamp
        Sender Display Name: $senderDisplayName
        Sender Name: $senderName
        Receiver Display Name: $receiverDisplayName
        Receiver Name: $receiverName
        Amount: $amount
        ''';
      } else {
        return 'Error: ${response.statusCode} - ${responseBody.body}';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }

  Widget _imageView() {
    Widget imageContainer = Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: selectedMedia != null
            ? Image.file(selectedMedia!)
            : const Center(
                child: Text(
                  "Select image",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
    );

    // Delete "selectedMedia = null" if want to still click.
    return selectedMedia == null
        ? GestureDetector(
            onTap: _pickImage,
            child: imageContainer,
          )
        : imageContainer;
  }
}
