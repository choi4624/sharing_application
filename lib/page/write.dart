import 'package:flutter/material.dart';
import 'package:test_project/repository/contents_repository.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  // textfield에서 입력받은 정보를 저장할 변수
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late String title;
  late String location;
  late String price;

  // textfield에서 입력받은 데이터를 변수에 저장하는 함수
  void _submitData() {
    title = _titleController.text;
    location = _locationController.text;
    price = _priceController.text;
    // 서버로 보내는 함수 작성(추가 예정)
    // void _summitToServer(){}
  }

  // ContensRepository에 새로운 데이터 추가하는 함수
  void _addData({
    //required String image,
    required String title,
    required String location,
    required String price,
  }) {
    ContensRepository.datas.add({
      'image': "assets/images/ex1.png", // 사진 첨수 기능 만들어야함
      'title': title,
      'location': location,
      'price': price,
      'like': "0", // 초기값 = 0, 이후 서버로부터 갱신 필요
    });
  }
  //Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.greenAccent,
            ),
          ),
          Flexible(
            flex: 8,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.blueAccent,
                  ),
                ),
                // Title textfield
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "제목을 입력해주세요",
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) => _titleController,
                    ),
                  ),
                ),
                // Location textfield
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "주소를 입력해주세요",
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                // Price textfield
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "가격을 입력해주세요",
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                // Content textfield
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Flexible(
                    flex: 10,
                    child: TextField(
                      //controller: ,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "내용을 입력해주세요",
                      ),
                      maxLength: 1000,
                      maxLines: 10,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _submitData();
                        _addData(
                          title: title,
                          location: location,
                          price: price,
                        );
                      },
                      child: const Text(
                        "Done",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.greenAccent,
            ),
          )
        ],
        // child: const TextField(
        //   //controller: ,
        //   maxLength: 1000,
      ),
    );
  }
}
