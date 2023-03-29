import 'package:flutter/material.dart';
import 'package:test_project/page/control.dart';

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
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          TextField(
                            controller: controller,
                            autofocus: true,
                            decoration:
                                const InputDecoration(labelText: 'ID 입력'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: controller2,
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
                                  if (controller.text == 'example' &&
                                      controller2.text == '1234') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const NextPage()));
                                  } else if (controller.text == 'example' &&
                                      controller2.text != '1234') {
                                    showSnackBar(context,
                                        const Text('잘못된 비밀번호입니다. 다시 입력해주세요.'));
                                  } else if (controller.text != 'example' &&
                                      controller2.text == '1234') {
                                    showSnackBar(context,
                                        const Text('잘못된 ID입니다. 다시 입력해주세요.'));
                                  } else {
                                    showSnackBar(
                                        context,
                                        const Text(
                                            '입력정보가 올바르지 않습니다. 다시 입력해주세요.'));
                                  }
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
                    })),
              ))
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
