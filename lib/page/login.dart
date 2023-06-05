import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/page/signup.dart';

import '../repository/contents_repository.dart';
import 'control.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // =======================================================
  TextEditingController userId = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  String? jwt;
  late int statusCode;
  Map<String, dynamic> payloadedJWT = {};
  // =======================================================
  // 앱내에 JWT 저장
  Future<void> saveJWT(String jwt, String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserInfo.jwt = jwt;
    });
    prefs.setString('jwt', jwt);
    prefs.setString('userId', userId);
  }

  Future<String?> getJWT() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<String?> _sendDataToServer({
    required String userId,
    required String password,
  }) async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': userId, 'password': password});
    final response = await http
        .post(
          uri,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final responseHeader = response.headers;
      if (responseHeader.isEmpty) {
        throw Exception("responseBody is Empty");
      }
      setState(() {
        final getToken = responseHeader['authorization']!;
        jwt = getToken.replaceFirst("Bearer ", "");
        statusCode = response.statusCode;
        saveJWT(getToken.replaceFirst("Bearer ", ""), userId);
      });
      return jwt;
    } else {
      setState(() {
        statusCode = response.statusCode;
      });
      print(response.statusCode);
      print(response.reasonPhrase);
      jwt = null;
      return throw Exception('Failed to send data');
    }
  }

  // JWT를 변수에 저장(어플 종료 후 삭제)
  Future<void> _saveJWT() async {
    jwt = await _sendDataToServer(
      userId: userId.text,
      password: userPassword.text,
    );
    if (jwt != null) {
      await _base64JWT();
    } else {
      jwt = null;
    }
  }

  Future<void> _base64JWT() async {
    await getJWT();
    List<String> jwtParts = jwt!.split('.');
    String encodedPayload = jwtParts[1];
    int mod4 = encodedPayload.length % 4;
    if (mod4 > 0) {
      encodedPayload += ('=' * (4 - mod4));
    }
    String jsonString = utf8.decode(base64Url.decode(encodedPayload));
    Map<String, dynamic> payloaded = json.decode(jsonString);
    payloadedJWT = payloaded;
    setState(() {
      UserInfo.userId = payloadedJWT['username'];
    });
    print(UserInfo.jwt);
    print(payloadedJWT);
  }

  // =======================================================
  Widget _bodyWidget() {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          //scrollDirection: Axis.vertical,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Flexible(
              flex: 5,
              child: Image.asset(
                "assets/images/appIcon.png",
              ),
            ),
            Flexible(
              flex: 10,
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.teal,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Builder(
                      builder: (context) {
                        return Column(
                          children: [
                            TextField(
                              controller: userId,
                              decoration:
                                  const InputDecoration(labelText: 'ID 입력'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextField(
                              controller: userPassword,
                              decoration:
                                  const InputDecoration(labelText: '비밀번호 입력'),
                              keyboardType: TextInputType.text,
                              obscureText: true, // 비밀번호 안보이도록 하는 것
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            ButtonTheme(
                              // minWidth: 100.0,
                              // height: 50.0,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await _saveJWT();
                                    if (statusCode == 200) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Control()),
                                          (route) => false);
                                    } else if (statusCode >= 400 &&
                                        statusCode <= 500) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 20, 0, 5),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "ID 또는 패스워드를 확인해주세요.",
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
                                                          MaterialStateColor
                                                              .resolveWith(
                                                        (states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .disabled)) {
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
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 20, 0, 5),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "ID 또는 패스워드를 확인해주세요.",
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
                                                          MaterialStateColor
                                                              .resolveWith(
                                                        (states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .disabled)) {
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
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 20, 0, 5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "아이디나 패스워드 혹은",
                                              ),
                                              Text(
                                                "인터넷 상태를 확인해주세요.",
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
                                                        MaterialStateColor
                                                            .resolveWith(
                                                      (states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .disabled)) {
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
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(312.7, 45),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: const Text(
                                  "로그인",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp()),
                                      );
                                    },
                                    child: const Text(
                                      '회원가입',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyWidget(),
    );
  }
}
