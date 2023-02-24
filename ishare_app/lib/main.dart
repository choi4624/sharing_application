import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// web data request

Future<Post> fetchPost() async {
  final response = await http.get(Uri.parse('https://ubuntu.i4624.tk/test'));
  if ( response.statusCode == 200) {
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

  Post({required this.userId, required this.id, required this.title, required this.body});

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
    home: Scaffold(
      appBar: AppBar(
        title: const Text('UmapMarket'),
        leading: IconButton(
            onPressed: () { print('menu clicked');  },
            icon: Icon(Icons.settings),
          ),
        actions: [
          IconButton(
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("nofification message"),
            ));  },
            icon: Icon(Icons.info),
          ),
          IconButton(
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("view message"),
            ));  },
            icon: Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("view message"),
            ));  },
            icon: Icon(Icons.abc),
          ),
        ],

        ),

      body: ListView(
          children: [
            Container(
                width: 800,height: 1200,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent,),
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Expanded(child: Row(
                  children: const [Text('welcome site', style: TextStyle(
                    color: Color(0xff19d933),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: 40,),)
                    ]
                  ),
                  ),
                    Expanded(child: Row(
                        children: const [ Text('welcome site', style: TextStyle(
                          color: Color(0xff19d933),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 40,),)

                        ]
                    ),
                    ),
                    Expanded(child: Row(
                        children: <Widget> [const Flexible ( child:
                          Text('web data',
                          style: TextStyle(fontSize: 40),)
                          )
                          ,Flexible ( child:FutureBuilder<Post>(
                            future: info,
                            builder: (context, sanpshot) {
                              if (sanpshot.hasData) {
                                return build(context);
                              }
                              else if (sanpshot.hasError) {
                                return Text("${sanpshot.error} 에러!");
                              }
                              return const CircularProgressIndicator();
                            }
                            )
                        )
                        ]
                    ),
                    ),
                  ],
                )
            ),
          ]
      ),

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
    )

    );
  }
}




/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/