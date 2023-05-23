import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      children: [
        Column(
          children: const [
            Text('data'),
            TextField(
              decoration: InputDecoration(
                  //label: ,
                  labelStyle: TextStyle(),
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      ],
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
