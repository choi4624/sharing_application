import 'package:flutter/material.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  //
  // 사용자의 텍스트 입력을 home 위젯에 있는 datas에 추가하는 함수 및 변수
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _submitData() {
    String title = _titleController.text;
    String location = _locationController.text;
    String price = _priceController.text;

    // Home.dart에 정의된 _addData() 함수를 사용하여 새로운 데이터 추가
    // const Home()._addData(
    //   "assets/images/ex1.png",
    //   title,
    //   location,
    //   price,
    // );

    Navigator.pop(context);
  }

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
                const Flexible(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      //controller: ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "제목을 입력해주세요",
                      ),
                    ),
                  ),
                ),
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
