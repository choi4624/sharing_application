import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_project/page/control.dart';
import 'package:test_project/repository/contents_repository.dart';
import 'package:kpostal/kpostal.dart';

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

  late String category; //
  late String productCategory; //

  late int price;
  final TextEditingController _priceController = TextEditingController();

  // 사용자의 이미지 저장하는 리스트
  final List<XFile> _selectedFiles = [];

  // ignore: unused_field
  late String _uploadedImageUrl;

  String productCategoryCurrentLocation = "default";
  String categoryCurrentLocation = "default";

  // 카테고리 선택
  final Map<String, dynamic> productCategoryOptionsTypeToString = {
    "default": "카테고리",
    "electronics": "디지털/전자",
    "tools": "공구",
    "clothes": "의류",
    "others": "기타"
  };

  // 거래방식 선택
  final Map<String, dynamic> boardCategoryOptionsTypeToString = {
    "default": "거래방식",
    "sell": "판매",
    "buy": "구매",
    "rental": "대여",
  };

  // 사용자의 다수의 image를 받기위한 생성자
  final ImagePicker _picker = ImagePicker();
  Future<void> _selectImages() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage(
        imageQuality: 100,
      );
      setState(() {
        if (selectedImages.isNotEmpty) {
          _selectedFiles.addAll(selectedImages);
        } else {
          //print('no image select');
        }
      });
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
    //print("Image List length: ${_selectedFiles.length.toString()}");
  }

  List<Map<String, dynamic>> imageData = [];
  List<dynamic> imageJsonData = [];
  Future _uploadImagesToServer({
    required List<XFile> selectedFiles,
  }) async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/image/upload');
    final request = http.MultipartRequest('POST', uri);
    for (var selectedFile in selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('filename', selectedFile.path),
      );
      request.fields['user'] = UserInfo.userId;
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      await _updateImageData();
    } else {
      throw Exception('Failed to send images');
    }
  }

  Future<void> _updateImageData() async {
    imageJsonData = await _getImageIdData();
    imageData = _convertImageJsonData(imageJsonData);
  }

  Future<List<dynamic>> _getImageIdData() async {
    var url = Uri.parse(
        'https://ubuntu.i4624.tk/image/sql/recent/${UserInfo.userId}/${_selectedFiles.length}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      imageJsonData = responseData;
      return imageJsonData;
    } else {
      throw Exception('Failed to get image data');
    }
  }

  List<Map<String, dynamic>> _convertImageJsonData(
      List<dynamic> imageJsonData) {
    return imageJsonData
        .map<Map<String, int>>((data) => {
              'imageUid': data[0],
            })
        .toList();
  }

  // Send Data To Server
  Future _sendDataToServer({
    required UserInfo user,
    required String userId,
    required String title,
    required String contents, // 카테고리
    required String productCategory,
    required String category, //거래방식
    required String location,
    required int price,
  }) async {
    await _uploadImagesToServer(selectedFiles: _selectedFiles);
    final uri = Uri.parse('https://ubuntu.i4624.tk/api/v1/post');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserInfo.jwt}'
    };
    final body = jsonEncode({
      'title': title,
      'content': contents,
      'location': location,
      'price': price,
      'writer': json.encode(user.toJson()),
      'category': category,
      'imageIds':
          imageData.map<int>((item) => item['imageUid'] as int).toList(),
      'boardCategory': category,
      'itemCategory': productCategory,
    });
    final response = await http
        .post(
          uri,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      //print(response.statusCode);
    } else {
      // print(response.statusCode);
      // print(response.reasonPhrase);
      throw Exception('Failed to send total data');
    }
  }

  // Appbar Widget
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.black,
        padding: EdgeInsets.zero,
        onPressed: () {
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
      backgroundColor: const Color.fromARGB(255, 192, 234, 255),
      elevation: 1,
      title: Row(
        children: const [
          Expanded(
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
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            child: TextButton(
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
                        ? const Color.fromARGB(255, 132, 206, 243)
                        : Colors.black),
              ),
              onPressed: () async {
                //거래방식 정보가 비어있을 때
                if (categoryCurrentLocation == "default") {
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
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.grey;
                                      } else {
                                        return const Color.fromARGB(
                                            255, 132, 206, 243);
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
                else if (productCategoryCurrentLocation == "default") {
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
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.grey;
                                      } else {
                                        return const Color.fromARGB(
                                            255, 132, 206, 243);
                                      }
                                    },
                                  ),
                                ),
                                child: const Text(
                                  "확인",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
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
                          SizedBox(
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
                } else if (_selectedFiles.isEmpty) {
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
                  _sendDataToServer(
                      user: UserInfo(),
                      userId: UserInfo.userId,
                      title: _titleController.text,
                      contents: _contentsController.text,
                      productCategory: productCategoryCurrentLocation,
                      category: categoryCurrentLocation,
                      location: _locationController.text,
                      price:
                          int.parse(_priceController.text.replaceAll(',', '')));
                  //print("데이터 전송");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Control()),
                  );
                }
              },
              child: const Text(
                "완료",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
          ),
        ),
      ],
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
                    onTap: () {},
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
                        width: 90,
                        child: Row(
                          children: [
                            //앱 내에서 좌측 상단바 출력을 위한 데이터
                            Text(
                              boardCategoryOptionsTypeToString[
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                  child: GestureDetector(
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
                          productCategoryCurrentLocation = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "electronics",
                            child: Text("디지털/전자"),
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
                              productCategoryOptionsTypeToString[
                                  productCategoryCurrentLocation]!,
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
                controller: _locationController,
                readOnly: true,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KpostalView(
                        callback: (Kpostal result) {
                          //print(result.address);
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
            // Contents textfield
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
          _selectImages();
        },
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 172, 227, 255),
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
