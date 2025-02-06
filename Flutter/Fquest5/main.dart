import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(JellyfishClassifierApp());
}

class JellyfishClassifierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JellyfishClassifierScreen(),
    );
  }
}

class JellyfishClassifierScreen extends StatefulWidget {
  @override
  _JellyfishClassifierScreenState createState() =>
      _JellyfishClassifierScreenState();
}

class _JellyfishClassifierScreenState extends State<JellyfishClassifierScreen> {
  String _predictionLabel = 'No Prediction';
  String _predictionScore = 'N/A';
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> fetchPrediction(Uint8List imageBytes) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    try {
      // 이미지 파일을 서버에 전송
      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'jellyfish.jpg',
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final jsonData = json.decode(data);
        setState(() {
          _predictionLabel = jsonData['predicted_label'];
          _predictionScore = jsonData['prediction_score'];
        });

        // 예측 클래스와 확률을 디버그 콘솔에 출력
        print("Prediction Label: ${jsonData['predicted_label']}");
        print("Prediction Score: ${jsonData['prediction_score']}");
      } else {
        print("Error: Server returned status code ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to fetch prediction: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      // 이미지 파일을 바이트 배열로 변환 후 예측 요청
      Uint8List imageBytes = await pickedFile.readAsBytes();
      fetchPrediction(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jellyfish Classifier'),
        centerTitle: true,
        leading: Icon(Icons.blur_circular), // 해파리 모양을 상징하는 아이콘
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 업로드한 이미지 출력
            if (_image != null)
              Image.file(
                File(_image!.path),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 예측 클래스 버튼
                ElevatedButton(
                  onPressed: _image == null
                      ? null
                      : () {
                          fetchPrediction(_image!.readAsBytesSync());
                        },
                  child: Text('Predict Class'),
                ),
                // 예측 확률 버튼
                ElevatedButton(
                  onPressed: _image == null
                      ? null
                      : () {
                          fetchPrediction(_image!.readAsBytesSync());
                        },
                  child: Text('Predict Score'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Prediction: $_predictionLabel',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Score: $_predictionScore',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

````
  <회고>
  server_fastapi_vgg16.py 파일에서 모듈을 임포트하고, 모듈의 함수를 통해 API로 결과를 전달하는 부분까지 확인하였습니다. (VNC에서 진행)
  하지만 Flutlab을 사용하여 애플리케이션을 구현하는 과정에서 어려움이 있었습니다. 다트 파일을 다시 검토하여 문제의 원인을 파악해볼 예정입니다.
  ```
