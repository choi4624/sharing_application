import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget build(BuildContext context) {
  return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Good day'),
          leading: IconButton(
            onPressed: () { print('menu clicked');  },
            icon: Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("nofification message"),
              ));  },
              icon: Icon(Icons.notification_add),
            ),
          ],
        ),

        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: 800,height: 1200,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent,),
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Expanded(child: Column(
                      children: const [Text('welcome site', style: TextStyle(
                        color: Color(0xff19d933),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 40,),)
                      ]
                  ),
                  ),
                    Expanded(child: Column(
                        children: const [ Text('welcome site', style: TextStyle(
                          color: Color(0xff19d933),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 40,),)

                        ]
                    ),
                    ),
                    Expanded(child: Column(
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
            )
        ),

        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home),
                Icon(Icons.message),
                Icon(Icons.add_alarm),
                Icon(Icons.search),
              ],
            ),
          ),
        ),
      )

  );
}