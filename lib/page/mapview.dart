import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:test_project/repository/contents_repository.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<NaverMapController> _controller = Completer();
  final MapType _mapType = MapType.Basic;

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 투명색
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
              ),
            ],
            color: Colors.white, // 배경색 지정
            borderRadius: BorderRadius.circular(7),
          ),
          child: TextField(
            //keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: InputBorder.none,
              hintText: UserInfo().address,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: NaverMap(
              onMapCreated: onMapCreated,
              mapType: _mapType,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
