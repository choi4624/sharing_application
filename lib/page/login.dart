import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_project/page/control.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LogIn(),
    );
  }
}

class _LogInState extends State<LogIn> {
  TextEditingController inputUserId = TextEditingController();
  TextEditingController inputUserPassword = TextEditingController();
  String? jwt;
  late String userId;
  late String userPassword;

  void controllerToTest() {
    userId = inputUserId.text;
    userPassword = inputUserPassword.text;
    _sendDataToServer(userId: userId, password: userPassword);
  }

  Future _sendDataToServer({
    required String userId,
    required String password,
  }) async {
    final uri = Uri.parse('https://ubuntu.i4624.tk/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'key': 'value'});
    final request = http.MultipartRequest('POST', uri);
    request.fields['username'] = userId;
    request.fields['password'] = password;
    final response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode(<String, String>{
            'username': userId,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 5)); //await request.send();
    if (response.statusCode == 200) {
      final responseHeader = response.headers;
      if (responseHeader.isEmpty) {
        print("responseBody is Empty");
      }
      setState(() {
        jwt = responseHeader['authorization']!;
        print(jwt);
        print("데이터 전송");
      });
    } else {
      print(response.reasonPhrase);
      throw Exception('Failed to send data');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
      body: GestureDetector(
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
                ), //로고가 필요할 경우 넣는 부분
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
                              controller: inputUserId,
                              autofocus: true,
                              decoration:
                                  const InputDecoration(labelText: 'ID 입력'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextField(
                              controller: inputUserPassword,
                              decoration:
                                  const InputDecoration(labelText: '비밀번호 입력'),
                              keyboardType: TextInputType.text,
                              obscureText: true, // 비밀번호 안보이도록 하는 것
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            ButtonTheme(
                                minWidth: 100.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //controllerToTest();
                                    _sendDataToServer(
                                        userId: inputUserId.text,
                                        password: inputUserPassword.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Control()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                ))
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
                  //print(jwtData);
                },
                child: const Text("Result"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Control();
  }
}
