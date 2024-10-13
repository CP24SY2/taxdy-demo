import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Apipage extends StatefulWidget {
  const Apipage({super.key});

  @override
  State<Apipage> createState() => _ApipageState();
}

class _ApipageState extends State<Apipage> {
  String extractedText = '';
  final ImagePicker _picker = ImagePicker();

  // กำหนด URL ของ API และ API Key
  final String apiUrl = 'https://api.slipok.com/api/line/apikey/31502';
  final String apiKey = 'SLIPOKUF6RYLZ';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String result = await _uploadSlip(imageFile);
      setState(() {
        extractedText = result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SlipOk API Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Slip Image'),
            ),
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
}
