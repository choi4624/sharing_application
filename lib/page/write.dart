import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';
import 'package:test_project/page/control.dart';
import 'package:test_project/repository/contents_repository.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  // textfield에서 입력받은 정보를 저장할 변수
  late String userId;
  late String userNickName;
  late String title;
  final TextEditingController _titleController = TextEditingController();
  late String contents;
  final TextEditingController _contentsController = TextEditingController();
  late String location;
  final TextEditingController _locationController = TextEditingController();
  late String transaction; //
  late String category; //
  late int price;
  final TextEditingController _priceController = TextEditingController();
  final picker = ImagePicker();
  // 다수의 이미지 저장용
  late List<XFile> image;
  // 하나의 이미지 저장용
  File? _imageFile;
  // ignore: unused_field
  late String _uploadedImageUrl;

  String categoryCurrentLocation = "default";
  String transactionCurrentLocation = "default";

  // 카테고리 선택
  final Map<String, dynamic> categoryOptionsTypeToString = {
    "default": "카테고리",
    "electronics": "디지털/가전",
    "tools": "공구",
    "clothes": "의류",
    "others": "기타"
  };

  // 거래방식 선택
  final Map<String, dynamic> transactionOptionsTypeToString = {
    "default": "거래방식",
    "sell": "판매",
    "buy": "구매",
    "rental": "대여",
  };

  // 사용자의 다수의 image를 받기위한 생성자
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
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

  // Future _selectImage() async {
  //   // ignore: deprecated_member_use
  //   final pickedFile = await picker.getImage(
  //     source: ImageSource.gallery,
  //   );
  //   setState(() {
  //     _imageFile = File(pickedFile!.path);
  //   });
  // }

  // textfield에서 입력받은 데이터를 변수에 저장하는 함수
  void _saveData() {
    userId = UserInfo().userId;
    userNickName = UserInfo().userNickName;
    //image = _selectedFiles;
    title = _titleController.text;
    contents = _contentsController.text;
    category = categoryCurrentLocation;
    transaction = transactionCurrentLocation;
    location = _locationController.text;
    price = int.parse(_priceController.text.replaceAll(',', ''));
  }

  // Send Data To Server
  Future sendDataToServer({
    required String userId,
    required String userNickName,
    required List<XFile> selectedFiles,
    required String title,
    required String contents,
    required String category,
    required String location,
    required int price,
  }) async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/example/upload');
    final request = http.MultipartRequest('POST', uri);
    for (var selectedFile in selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('filename', selectedFile.path),
      );
    }
    request.fields['userId'] = userId;
    request.fields['userNickName'] = userNickName;
    request.fields['title'] = title;
    request.fields['contents'] = contents;
    request.fields['category'] = category;
    request.fields['location'] = location;
    request.fields['price'] = price.toString();
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

  // Appbar Widget
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            padding: EdgeInsets.zero,
            onPressed: () {
              //initState();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Control()),
              );
            },
            constraints: const BoxConstraints(),
            splashRadius: 24,
            iconSize: 24,
            // 아래의 ButtonStyle 추가
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "게시글 작성",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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
              // 거래방식 정보가 비어있을 때
              if (transactionCurrentLocation == "default") {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "거래방식을 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    } else {
                                      return Colors.blue;
                                    }
                                  },
                                ),
                              ),
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 카테고리 정보가 비어있을 때
              else if (categoryCurrentLocation == "default") {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "카테고리를 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    } else {
                                      return Colors.blue;
                                    }
                                  },
                                ),
                              ),
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 제목 정보가 비어있을 때
              else if (_titleController.text.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "제목을 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    } else {
                                      return Colors.blue;
                                    }
                                  },
                                ),
                              ),
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 지역 정보가 비어있을 때
              else if (_locationController.text.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "주소를 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 가격 정보가 비어있을 때
              else if (_priceController.text.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "가격을 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 내용 정보가 비어있을 때
              else if (_contentsController.text.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "내용을 입력해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (_imageFile == null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "사진을 첨부해주세요",
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              // 모든 정보가 입력되었을 때
              else {
                _saveData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Control()),
                );
              }
            },
            child: const Text(
              "완료",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose(); // 컨트롤러를 제거하여 메모리 누수를 방지
    super.dispose();
  }

  Widget _makeTextArea() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        return Column(
          children: [
            // Category textfield
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 0, 10),
                  child: GestureDetector(
                    onTap: () {
                      print("click event");
                    },
                    child: PopupMenuButton<String>(
                      offset: const Offset(0, 30),
                      shape: ShapeBorder.lerp(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          1),
                      onSelected: (String value) {
                        setState(() {
                          transactionCurrentLocation = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "sell",
                            child: Text("판매"),
                          ),
                          const PopupMenuItem(
                            value: "buy",
                            child: Text("구매"),
                          ),
                          const PopupMenuItem(
                            value: "rental",
                            child: Text("대여"),
                          ),
                        ];
                      },
                      //좌측 상단 판매, 구매, 대여 선택바
                      child: SizedBox(
                        width: 76,
                        child: Row(
                          children: [
                            //앱 내에서 좌측 상단바 출력을 위한 데이터
                            Text(
                              transactionOptionsTypeToString[
                                  transactionCurrentLocation]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                  child: GestureDetector(
                    onTap: () {
                      print("click event");
                      //ContentsRepository().fetchBoardList();
                    },
                    child: PopupMenuButton<String>(
                      offset: const Offset(0, 30),
                      shape: ShapeBorder.lerp(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          1),
                      onSelected: (String value) {
                        setState(() {
                          categoryCurrentLocation = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "electronics",
                            child: Text("디지털/가전"),
                          ),
                          const PopupMenuItem(
                            value: "tools",
                            child: Text("공구"),
                          ),
                          const PopupMenuItem(
                            value: "clothes",
                            child: Text("의류"),
                          ),
                          const PopupMenuItem(
                            value: "others",
                            child: Text("기타"),
                          ),
                        ];
                      },
                      //좌측 상단 판매, 구매, 대여 선택바
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //앱 내에서 좌측 상단바 출력을 위한 데이터
                            Text(
                              categoryOptionsTypeToString[
                                  categoryCurrentLocation]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Title textfield
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Center(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 20),
                    hintText: "제목을 입력해주세요",
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) => _titleController,
                ),
              ),
            ),
            // Location textfield
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: _locationController, // 주소를 입력받는 TextField에 컨트롤러 할당
                readOnly: true, // TextField를 읽기 전용으로 설정하여 사용자 입력을 막음
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KpostalView(
                        callback: (Kpostal result) {
                          print(result.address);
                          setState(() {
                            location =
                                result.address; // 주소를 선택하면 해당 값을 상태 변수에 저장
                            _locationController.text =
                                location; // 상태 변수의 값을 TextField에 출력
                          });
                        },
                      ),
                    ),
                  );
                },
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 20),
                  hintText: "주소를 입력해주세요",
                ),
              ),
            ),
            // Price textfield
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 20),
                  hintText: "가격을 입력해주세요",
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  // 입력 값에서 ',' 제거
                  String price = value.replaceAll(',', '');
                  // 빈 문자열인 경우 그대로 입력
                  if (price.isEmpty) {
                    _priceController.value = TextEditingValue(
                      text: '',
                      selection: TextSelection.fromPosition(
                        const TextPosition(offset: 0),
                      ),
                    );
                    return;
                  }
                  // 1000단위로 ',' 추가
                  price = NumberFormat('#,###').format(int.parse(price));
                  // 변경된 값을 다시 입력
                  _priceController.value = TextEditingValue(
                    text: price,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: price.length),
                    ),
                  );
                },
              ),
            ),
            // Content textfield
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: _contentsController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(),
                  hintText: "내용을 입력해주세요",
                ),
                maxLength: 1000,
                maxLines: 10,
                textInputAction: TextInputAction.done,
              ),
            ),
            // image viewer
            SizedBox(
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
            //Single image
            //   SizedBox(
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: _imageFile != null
            //             ? Container(
            //                 decoration: BoxDecoration(
            //                   border: Border.all(
            //                     color: Colors.transparent,
            //                   ),
            //                 ),
            //                 child: SizedBox(
            //                   width: 150,
            //                   height: 150,
            //                   child: Image.file(
            //                     File(_imageFile!.path),
            //                     fit: BoxFit.scaleDown,
            //                   ),
            //                 ),
            //               )
            //             : Container(),
            //       ),
            //     ),
            //   )
          ],
        );
      },
      itemCount: 1,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _makeTextArea(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('이미지 추가');
          _selectImages();
          //_selectImage();
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
