import 'package:flutter/material.dart';
import 'package:test_project/page/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Widget makeInput({label, obsureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obsureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.grey,
            )),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_sharp),
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
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: const [
          Expanded(
            child: Center(
              child: Text(
                "회원가입",
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
        TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.fromLTRB(0, 0, 20, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            foregroundColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.pressed)
                    ? Colors.blue
                    : Colors.black),
          ),
          onPressed: () async {},
          child: const Text(
            "완료",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _bodyWiget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            makeInput(label: "이름"),
                            makeInput(label: "전화번호"),
                            makeInput(label: "ID"),
                            makeInput(label: "Password", obsureText: true),
                            makeInput(
                                label: "Confirm Pasword", obsureText: true)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black))),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {},
                        //color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("계정이 이미 존재하시나요? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogIn()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWiget(),
    );
  }
}
