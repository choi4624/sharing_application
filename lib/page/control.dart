import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:test_project/page/chat.dart';
import 'package:test_project/page/image.dart';
import 'package:test_project/page/home.dart';
import 'package:test_project/page/mapview.dart';
import 'package:test_project/page/user.dart';
import 'package:test_project/page/write.dart';

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  List<Map<String, String>> datas = [];
  int _currentPageIndex = 0;

  // 각 페이지로 이동
  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
      case 1:
        return const Write();
      case 2:
        return const MapView();
      case 3:
        return const Chat();
      case 4:
        return const User();
      default:
        return Home();
    }
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22),
      ),
      label: label,
    );
  }

  // 바텀 네비게이션
  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "글 작성"),
        _bottomNavigationBarItem("location", "지도"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "사용자"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
