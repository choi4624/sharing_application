import 'package:flutter/material.dart';
import 'package:test_project/repository/contents_repository.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Center(
          child: Text(
            "${ContentsRepository().data}",
          ),
        ),
      ),
    );
  }
}
