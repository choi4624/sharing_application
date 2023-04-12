import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  // 다수의 이미지 저장용
  late List<XFile> image;
  // ignore: unused_field
  late String _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final picker = ImagePicker();

  Future<void> _selectImages() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage(
        imageQuality: 100,
      );
      setState(() {
        if (selectedImages.isNotEmpty) {
          _selectedFiles.addAll(selectedImages);
        } else {
          print('no image select');
        }
      });
    } catch (e) {
      print(e);
    }
    print("Image List length: ${_selectedFiles.length.toString()}");
  }

  // Dio
  // Future _uploadImage() async {
  //   final uri = Uri.parse('https://ubuntu.i4624.tk/image/upload');
  //   final formData = FormData.fromMap({
  //     'filename': await MultipartFile.fromFile(_imageFile!.path),
  //   });
  //   try {
  //     final response = await Dio().postUri(uri, data: formData);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _uploadedImageUrl = response.data['imageUrl'];
  //       });
  //     } else {
  //       print(response.statusMessage);
  //     }
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  // }

  Future _sendDataToServer({
    required List<XFile> selectedFiles,
  }) async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/image/upload');
    final request = http.MultipartRequest('POST', uri);
    for (var selectedFile in selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('filename', selectedFile.path),
      );
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      setState(() {
        _uploadedImageUrl = jsonResponse['imageUrl'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          TextButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              foregroundColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.pressed)
                      ? Colors.blue
                      : Colors.black),
            ),
            onPressed: () {
              print("이미지 업로드");
              _sendDataToServer(selectedFiles: _selectedFiles);
            },
            child: const Text(
              "보내기",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Center(
        child: SizedBox(
          child: Wrap(
            spacing: 8.0,
            children: _selectedFiles
                .map((file) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 167, 167, 167),
                          ),
                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            File(file.path),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('이미지 추가');
          _selectImages();
        },
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 200, 200, 200),
        label: const Text(
          "이미지 추가",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
