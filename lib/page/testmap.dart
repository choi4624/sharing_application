// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';

// class MapView extends StatefulWidget {
//   const MapView({Key? key}) : super(key: key);

//   @override
//   State<MapView> createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   PreferredSizeWidget _appbarWidget() {
//     return AppBar(
//       title: Container(),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//     );
//   }

//   Widget _bodyWidget() {
//     return NaverMap(
//     options: const NaverMapViewOptions(), // 지도 옵션을 설정할 수 있습니다.
//     forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
//     onMapReady: (controller) {},
//     onMapTapped: (point, latLng) {},
//     onSymbolTapped: (symbol) {},
//     onCameraChange: (position, reason) {},
//     onCameraIdle: () {},
//     onSelectedIndoorChanged: (indoor) {},
// )
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//     //_getMyLocation();
//     return Scaffold(
//       appBar: _appbarWidget(),
//       extendBodyBehindAppBar: true,
//       body: _bodyWidget(),
//     );
//   }
// }
