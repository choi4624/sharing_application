import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../repository/contents_repository.dart';
import 'keyboardKey.dart';

class PIN extends StatefulWidget {
  Map<String, dynamic> data;
  PIN({Key? key, required this.data}) : super(key: key);

  @override
  State<PIN> createState() => _PINState();
}

class _PINState extends State<PIN> {
  late String amount = '';
  late String currentLocation;
  late String cabinetLocation;
  late int responseStatusCode;

  //앱 내에서 좌측 상단바 출력을 위한 데이터
  final Map<String, String> optionsTypeToString = {
    "setting": "PIN 설정",
    "auth": "PIN 해제",
  };
  final Map<String, dynamic> cabinetNumberToString = {
    "default": "캐비넷 번호",
    "1": "1번 캐비넷",
    "2": "2번 캐비넷",
  };
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    amount = '';
    cabinetLocation = "default";
    currentLocation = "setting";
    responseStatusCode = 0;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
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
      backgroundColor: Colors.white, //const Color.fromARGB(255, 184, 210, 255),
      elevation: 1.5, // 그림자를 표현되는 높이 3d 측면의 높이를 뜻함.
      actions: [
        GestureDetector(
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                1),
            onSelected: (String value) {
              setState(() {
                currentLocation = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "setting",
                  child: Text("PIN 설정"),
                ),
                const PopupMenuItem(
                  value: "auth",
                  child: Text("PIN 해제"),
                ),
              ];
            },
            //좌측 상단 판매, 구매, 대여 선택바
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  //앱 내에서 좌측 상단바 출력을 위한 데이터
                  Text(
                    optionsTypeToString[currentLocation]!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
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
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', const Icon(Icons.keyboard_backspace)],
  ];

  onNumberPress(val) {
    setState(() {
      amount = amount + val;
    });
  }

  onBackspacePress(val) {
    setState(() {
      amount = amount.substring(0, amount.length - 1);
    });
  }

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
            children: x.map((y) {
              return Expanded(
                child: NumKeyboardKey(
                  label: y,
                  onTap: y is Widget ? onBackspacePress : onNumberPress,
                  value: y,
                ),
              );
            }).toList(),
          ),
        )
        .toList();
  }

  renderConfirmButton() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 132, 204, 252),
              ),
              child: MaterialButton(
                onPressed: () async {
                  if (cabinetLocation == "default") {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 20, 0, 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "캐비넷을 선택해주세요",
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Center(
                              child: SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 132, 206, 243),
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
                  } else if (amount == '' || amount.length < 4) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 20, 0, 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "PIN 번호를 올바르게 입력해주세요",
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Center(
                              child: SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 132, 206, 243),
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
                  } else {
                    // PIN 등록(등록자)
                    if (optionsTypeToString[currentLocation] ==
                            optionsTypeToString["setting"] &&
                        widget.data["username"] == UserInfo.userId) {
                      await _sendPINDataToServer(
                        cabinetNum: int.parse(cabinetLocation),
                        pinNum: int.parse(amount),
                        postId: widget.data['postId'],
                      );
                      if (responseStatusCode == 200) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${optionsTypeToString[currentLocation]}이 완료되었습니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                      } else if (responseStatusCode == 400 &&
                          optionsTypeToString[currentLocation] ==
                              optionsTypeToString["setting"]) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${cabinetNumberToString[cabinetLocation]}은 현재 사용중입니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                      } else if (responseStatusCode == 401 &&
                          optionsTypeToString[currentLocation] ==
                              optionsTypeToString["auth"]) {}
                    }
                    // PIN 해제(등록자)
                    else if (optionsTypeToString[currentLocation] ==
                            optionsTypeToString["auth"] &&
                        widget.data["username"] == UserInfo.userId) {
                      await _sendPINDataToServer(
                        cabinetNum: int.parse(cabinetLocation),
                        pinNum: int.parse(amount),
                        postId: widget.data['postId'],
                      );
                      if (responseStatusCode == 200) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${optionsTypeToString[currentLocation]}가 완료되었습니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "PIN 번호가 올바르지 않습니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                    }
                    // PIN 해제(이용자)
                    else if (optionsTypeToString[currentLocation] ==
                            optionsTypeToString["auth"] &&
                        widget.data["username"] != UserInfo.userId) {
                      await _sendPINDataToServer(
                        cabinetNum: int.parse(cabinetLocation),
                        pinNum: int.parse(amount),
                        postId: widget.data['postId'],
                      );
                      if (responseStatusCode == 200) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${optionsTypeToString[currentLocation]}가 완료되었습니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "PIN 번호가 올바르지 않습니다.",
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 132, 206, 243),
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
                    } else {
                      print(UserInfo.userId);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 20, 0, 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "게시글 작성자만 ${optionsTypeToString["setting"]}이 가능합니다.",
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              Center(
                                child: SizedBox(
                                  width: 250,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 132, 206, 243),
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
                  }
                },
                minWidth: double.infinity,
                height: 55,
                child: const Text(
                  "확인",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                // child: const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 16.0),
                //   child: Text(
                //     '확인',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  renderText() {
    String display = 'PIN 번호';
    TextStyle style = const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 50.0,
        letterSpacing: 15);

    if (amount.isNotEmpty) {
      display = amount;
      style = style.copyWith(
        color: Colors.black,
      );
    } else {
      style = const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 40.0,
          letterSpacing: 5);
    }
    return Expanded(
      child: Center(
        child: Text(
          display,
          style: style,
        ),
      ),
    );
  }

  //
  Widget renderCabinetNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 0, 10),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 30),
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1),
        onSelected: (String value) {
          setState(() {
            cabinetLocation = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: "1",
              child: Text("1번 캐비넷"),
            ),
            const PopupMenuItem(
              value: "2",
              child: Text("2번 캐비넷"),
            ),
          ];
        },
        //좌측 상단 판매, 구매, 대여 선택바
        child: SizedBox(
          width: 130,
          child: Row(
            children: [
              //앱 내에서 좌측 상단바 출력을 위한 데이터
              Text(
                cabinetNumberToString[cabinetLocation]!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
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
    );
  }

  // Send PIN Data To Server
  Future _sendPINDataToServer({
    required int cabinetNum,
    required int postId,
    required int pinNum,
  }) async {
    // 서버에 pin 번호를 보내는 주소 -> 바뀔 가능성 O
    final uri = Uri.parse('https://ubuntu.i4624.tk/pin/$currentLocation');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserInfo.jwt}'
    };
    final body = jsonEncode({
      'cabinet': cabinetNum,
      'postid': postId,
      'pin': amount,
    });
    final response = await http
        .post(
          uri,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      setState(() {
        responseStatusCode = response.statusCode;
      });
      print(response.statusCode);
      return response.statusCode;
    } else {
      setState(() {
        responseStatusCode = response.statusCode;
      });
      print(response.body);
      print(response.statusCode);
      //throw Exception('Failed to send total data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // 수정된 부분
                children: [
                  renderCabinetNumber(),
                ],
              ),
              renderText(),
              ...renderKeyboard(),
              Container(height: 16.0),
              renderConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }
}
