import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:test_project/page/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'v2v7x0th03');
  permission();
  runApp(const MyApp());
}

Future<bool> permission() async {
  Map<Permission, PermissionStatus> status =
      await [Permission.location].request();
  if (await Permission.location.isGranted) {
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "STS",
      theme: ThemeData(
        //primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LogIn(),
    );
  }
}
