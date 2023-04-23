import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/page/control.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController userId = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  String? jwt;

  Future<void> saveJWT(String jwt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt', jwt);
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
        print("responseBody is Empty");
      }
      setState(() {
        jwt = responseHeader['authorization']!;
        print(jwt);
      });
      return jwt;
    } else {
      print(response.reasonPhrase);
      return throw Exception('Failed to send data');
    }
  }

  Future<void> _getTest() async {
    var url = Uri.parse('https://ubuntu.i4624.tk/api/v1/user');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseData);
    } else {
      throw Exception('Failed to get data');
    }
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: const Text('로그인'),
      elevation: 0.0,
      backgroundColor: Colors.redAccent,
      centerTitle: true,
    );
  }

  Widget _bodyWidget() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50)),
            const Center(
              child: Image(
                image: AssetImage("assets/images/ex1.png"),
                width: 170.0,
              ),
            ),
            Form(
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
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () async {
                                  jwt = await _sendDataToServer(
                                    userId: userId.text,
                                    password: userPassword.text,
                                  );
                                  if (jwt != null) {
                                    saveJWT(jwt!);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Control(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("로그인 실패"),
                                          content: const Text(
                                              "아이디와 비밀번호를 다시 확인해주세요."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("확인"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                child: const Text("로그인"),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _getTest();
              },
              child: const Text("Get Test"),
            ),
            TextButton(
              onPressed: () {
                print(jwt);
              },
              child: const Text("Result"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
