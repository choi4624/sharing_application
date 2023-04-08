import 'dart:convert';

import 'package:http/http.dart' as http;

class UserInfo {
  late String userId = "01";
  late String userNickName = "user_1";
  late String password;
  late String address = "경기도 안양시 동안구";
  var defaultImage = "assets/images/ex1.png";
  //var defaultImage = "https://ubuntu.i4624.tk/view/edit_1566023586912.jpg";
}

class ContentsRepository {
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> datas = {};

  void jsonToData() {
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      // category 값을 기준으로 Map에 저장합니다.
      if (datas[item['boardCategory']] == null) {
        datas[item['boardCategory']] = [item];
      } else {
        datas[item['boardCategory']]!.add(item);
      }
    }
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    var url = Uri.parse('https://ubuntu.i4624.tk/boardapi/boardlist');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      data = responseData
          .map((dynamic item) => Map<String, dynamic>.from(item))
          .toList();
      jsonToData();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> loadContentsFromLocation(
      String location) async {
    await loadData();
    jsonToData();
    return datas[location]!;
  }
}
