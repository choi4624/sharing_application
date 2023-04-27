// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:test_project/repository/contents_repository.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  final TextEditingController _textEditingController = TextEditingController();
  LocationData? _locationData;
  String? _locationText;
  late EdgeInsets safeArea;
  double drawerHeight = 0;

  NLatLng _initialPosition = const NLatLng(0, 0);
  late NaverMapController _controller;
  //late GeocodingPlatform _geocoding;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // 마커
  // 세개의 오버레이 생성
  final marker1 =
      NMarker(id: '1', position: const NLatLng(37.5666102, 126.9783881));
  //final marker2 = NMarker(id: '2', position: NLatLng(latitude, longitude));

  late List marker = [];
  void makeMaker() {
    for (int i = 0; i < ContentsRepository().datas.length; i++) {
      marker[i] = ContentsRepository().datas[i]["image"];
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = NLatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _goToAddress(String address) async {
    const apiKey =
        "6AWAOaVaaf3gncmk0OMxo6dGW7xBfco7Yf2ZfPTR"; // 여기에 발급받은 인증키를 입력하세요
    final encodedAddress = Uri.encodeComponent(address);
    final apiUrl =
        "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$encodedAddress";
    final headers = {
      "X-NCP-APIGW-API-KEY-ID": apiKey,
      "X-NCP-APIGW-API-KEY": apiKey
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      final jsonResult = jsonDecode(response.body);
      final addresses = jsonResult["addresses"];
      final first = addresses[0];
      final latitude = double.parse(first["y"]);
      final longitude = double.parse(first["x"]);
      _controller.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(latitude, longitude),
            zoom: 15,
          ),
        ),
      );
      setState(() {
        _locationData = null;
        _locationText = "($latitude, $longitude)";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: _textEditingController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "주소를 입력하세요",
            border: InputBorder.none,
          ),
          onFieldSubmitted: (value) {
            _goToAddress(value);
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _bodyWidget() {
    return NaverMap(
      onMapReady: (controller) {
        _controller = controller;
        _controller.addOverlay(marker1);
      },
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: _initialPosition,
          zoom: 16,
        ),
        // minZoom: 10,
        // maxZoom: 16,
        maxTilt: 30,
        symbolScale: 1,
        locationButtonEnable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    safeArea = MediaQuery.of(context).padding;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      appBar: _appbarWidget(),
      extendBodyBehindAppBar: true,
      body: _initialPosition.latitude == 0 && _initialPosition.longitude == 0
          ? const Center(child: CircularProgressIndicator())
          : _bodyWidget(),
    );
  }
}
