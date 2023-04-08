import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final TextEditingController _textEditingController = TextEditingController();
  late EdgeInsets safeArea;
  double drawerHeight = 0;

  late NLatLng _initialPosition;
  late NaverMapController _controller;
  //late GeocodingPlatform _geocoding;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //_geocoding = GeocodingPlatform.instance;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = NLatLng(position.latitude, position.longitude);
    });
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
            //_goToAddress(value);
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
      },
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: _initialPosition,
          zoom: 16,
        ),
        minZoom: 10,
        maxZoom: 16,
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
      body: _bodyWidget(),
    );
  }
}
