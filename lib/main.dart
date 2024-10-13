import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() => runApp(TaxdyApp());

class TaxdyApp extends StatelessWidget {
  const TaxdyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SlipOkScreen(),
    );
  }
}

class SlipOkScreen extends StatefulWidget {
  const SlipOkScreen({super.key});

  @override
  _SlipOkScreenState createState() => _SlipOkScreenState();
}

class _SlipOkScreenState extends State<SlipOkScreen> {
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

      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody.body);

        // ดึงข้อมูลที่ต้องการจาก response
        String transDate = data['data']['transDate'];
        String transTime = data['data']['transTime'];
        String transTimestamp = data['data']['transTimestamp'];
        String senderDisplayName = data['data']['sender']['displayName'];
        String senderName = data['data']['sender']['name'];
        String receiverDisplayName = data['data']['receiver']['displayName'];
        String receiverName = data['data']['receiver']['name'];
        String amount = data['data']['amount'].toString();

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
