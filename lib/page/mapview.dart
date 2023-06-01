// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:test_project/repository/contents_repository.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Future<Map<String, dynamic>> _loadContents() async {
    return ContentsRepository().loadRepeaterFromLocation();
  }

  SnappingSheetController snappingSheetController = SnappingSheetController();
  @override
  void initState() {
    super.initState();
    snappingSheetController = SnappingSheetController();
    _getCurrentLocation();
  }

  final TextEditingController _textEditingController = TextEditingController();
  LocationData? _locationData;
  String? _locationText;
  late EdgeInsets safeArea;
  double drawerHeight = 0;

  NLatLng _initialPosition = const NLatLng(0, 0);
  late NaverMapController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // 마커
  final kyonggiUniRepeater =
      NMarker(id: '1', position: const NLatLng(37.3, 127.0347399));

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = NLatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _goToAddress(String address) async {
    const apiKey = "6AWAOaVaaf3gncmk0OMxo6dGW7xBfco7Yf2ZfPTR";
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
      print(jsonResult);
      setState(() {
        _locationData = null;
        _locationText = "($latitude, $longitude)";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _goToRepeaterAddress(String address) async {
    const apiKey = "6AWAOaVaaf3gncmk0OMxo6dGW7xBfco7Yf2ZfPTR";
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
      print(jsonResult);
      setState(() {
        _locationData = null;
        _locationText = "($latitude, $longitude)";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget _makeDataList(Map<String, dynamic>? datas) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            _goToAddress(datas['location']).then((_) {
              snappingSheetController.snapToPosition(
                const SnappingPosition.factor(
                  positionFactor: 0.053,
                  snappingCurve: Curves.bounceOut,
                  snappingDuration: Duration(seconds: 1),
                  grabbingContentOffset: GrabbingContentOffset.bottom,
                ),
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/No_image.jpg',
                    //datas["image"],
                    width: 100,
                    height: 100,
                    scale: 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas!["title"]!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          datas["location"]!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 1, // 상품 목록의 개수
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  // 리스트 출력을 위한 기능
  Widget _productList() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("데이터를 불러올 수 없습니다."));
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }
          return const Center(child: Text("해당 거래방식에 대한 데이터가 없습니다."));
        });
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: null,
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
            //_direction15Test(value);
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _bodyWidget() {
    return SnappingSheet(
      controller: snappingSheetController,
      grabbingHeight: 40,
      grabbing: Container(
        height: 56,
        color: Colors.white,
        alignment: Alignment.center,
        child: const Text('지도 리스트'),
      ),
      sheetBelow: SnappingSheetContent(
        sizeBehavior: const SheetSizeFill(),
        draggable: true,
        child: Container(
          height: 56,
          color: Colors.white,
          alignment: Alignment.center,
          child: _productList(),
        ),
      ),
      snappingPositions: const [
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.pixels(
          positionPixels: 500,
          snappingCurve: Curves.elasticOut,
          snappingDuration: Duration(milliseconds: 1750),
        ),
        SnappingPosition.factor(
          positionFactor: 1.0,
          snappingCurve: Curves.bounceOut,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ],
      child: NaverMap(
        onMapReady: (controller) {
          _controller = controller;
          _controller.addOverlay(kyonggiUniRepeater);
        },
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: _initialPosition,
            zoom: 16,
          ),
          maxTilt: 30,
          symbolScale: 1,
          locationButtonEnable: true,
        ),
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
