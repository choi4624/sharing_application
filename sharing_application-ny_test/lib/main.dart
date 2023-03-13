import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/page/control.dart';

// web data request

Future<Post> fetchPost() async {
  final response = await http.get(Uri.parse('https://ubuntu.i4624.tk/test'));
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['_links'],
      id: json['profile'],
      title: json['href'],
      body: json['href'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "너도나도",
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Control(),
    );
  }
}
// 원본 코드
/*
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _InfoPageState();
}

class _InfoPageState extends State<MyApp> {
  Future<Post>? info;

  @override
  void initState() {
    super.initState();
    info = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('UmapMarket'),
            leading: IconButton(
              onPressed: () {
                print('menu clicked');
              },
              icon: const Icon(Icons.settings),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("nofification message"),
                  ));
                },
                icon: const Icon(Icons.info),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("view message"),
                  ));
                },
                icon: const Icon(Icons.menu),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("view message"),
                  ));
                },
                icon: const Icon(Icons.abc),
              ),
            ],
          ),
          body: ListView(children: [
            Container(
                width: 800,
                height: 1200,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.lightBlueAccent,
                  ),
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(10, 10)),
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Row(children: const [
                        Text(
                          'welcome site',
                          style: TextStyle(
                            color: Color(0xff19d933),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 40,
                          ),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Row(children: const [
                        Text(
                          'welcome site',
                          style: TextStyle(
                            color: Color(0xff19d933),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 40,
                          ),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Row(children: <Widget>[
                        const Flexible(
                            child: Text(
                          'web data',
                          style: TextStyle(fontSize: 40),
                        )),
                        Flexible(
                            child: FutureBuilder<Post>(
                                future: info,
                                builder: (context, sanpshot) {
                                  if (sanpshot.hasData) {
                                    return build(context);
                                  } else if (sanpshot.hasError) {
                                    return Text("${sanpshot.error} 에러!");
                                  }
                                  return const CircularProgressIndicator();
                                }))
                      ]),
                    ),
                  ],
                )),
          ]),
          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.home),
                  Icon(Icons.map_rounded),
                  Icon(Icons.notification_add_sharp),
                  Icon(Icons.search),
                  Icon(Icons.chat_bubble),
                ],
              ),
            ),
          ),
        ));
  }
}
*/
