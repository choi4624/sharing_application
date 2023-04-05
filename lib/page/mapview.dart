import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<NaverMapController> _controller = Completer();
  final MapType _mapType = MapType.Basic;
  LocationData? _locationData;
  String? _locationText;
  final TextEditingController _textEditingController = TextEditingController();

  final String _searchQuery = '';

  Future<void> _getMyLocation() async {
    final location = Location(); // create Location instance
    LocationData?
        currentLocation; // variable to hold the user's current location
    try {
      currentLocation =
          await location.getLocation(); // get user's current location
      setState(() {
        // update state with new location information
        _locationData = currentLocation;
        _locationText =
            "(${currentLocation?.latitude}, ${currentLocation?.longitude})";
      });
    } catch (e) {
      print("Error: 주소를 받아오는데 실패했습니다.");
    }
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  Future<void> _goToMyLocation() async {
    final location = Location(); // create Location instance
    LocationData?
        currentLocation; // variable to hold the user's current location
    try {
      currentLocation =
          await location.getLocation(); // get user's current location
      setState(() {
        // update state with new location information
        _locationData = currentLocation;
        _locationText =
            "(${currentLocation?.latitude}, ${currentLocation?.longitude})";
      });
    } catch (e) {
      print("Error: $e");
    }

    if (currentLocation != null) {
      // if the user's location was retrieved successfully
      final controller =
          await _controller.future; // wait for map controller to be available
      controller.moveCamera(
        // move camera to user's location
        CameraUpdate.toCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15,
          ),
        ),
      );
    }
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
      final controller = await _controller.future;
      controller.moveCamera(
        CameraUpdate.toCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
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
    final initialCameraPosition = _locationData != null
        ? CameraPosition(
            target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
            zoom: 15,
          )
        : const CameraPosition(
            target: LatLng(37.5666102, 126.9783881),
            zoom: 15,
          );
    return Stack(
      children: [
        NaverMap(
          mapType: _mapType,
          onMapCreated: onMapCreated,
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              _goToMyLocation();
            },
            child: const Icon(Icons.my_location),
          ),
        ),
        if (_locationData != null)
          Positioned(
            bottom: 80,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Text(
                _locationText!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          child: Container(
            child: TextButton(
              style: const ButtonStyle(),
              onPressed: () {
                print(_locationText);
              },
              child: const Text("test"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    //_getMyLocation();
    return Scaffold(
      appBar: _appbarWidget(),
      extendBodyBehindAppBar: true,
      body: _bodyWidget(),
    );
  }
}
