import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  XFile? _imageFile;
  // ignore: unused_field
  late String _uploadedImageUrl;

  final picker = ImagePicker();

  Future pickImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = XFile(pickedFile!.path);
    });
  }

  // Dio
  Future uploadImage() async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/image/upload');
    final formData = FormData.fromMap({
      'filename': await MultipartFile.fromFile(_imageFile!.path),
    });
    try {
      final response = await Dio().postUri(uri, data: formData);
      if (response.statusCode == 200) {
        setState(() {
          _uploadedImageUrl = response.data['imageUrl'];
        });
      } else {
        print(response.statusMessage);
      }
    } on DioError catch (e) {
      print(e.message);
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
              uploadImage();
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
      body: SizedBox(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: _imageFile != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                    child: SizedBox(
                      width: 500,
                      height: 500,
                      child: Image.file(
                        File(_imageFile!.path),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
                : Container(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('이미지 추가');
          pickImage();
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
