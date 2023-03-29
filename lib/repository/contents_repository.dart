import 'dart:convert';
import 'package:http/http.dart' as http;

// Future<http.Response> fetchPost() async {
//   var url = Uri.parse('https://ubuntu.i4624.tk/json');
//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
//     return Post.fromJson(json.decode(response.body));
//   } else {
//     // 만약 응답이 OK가 아니면, 에러를 던집니다.
//     throw Exception('Failed to load post');
//   }
// }
class UserInfo {
  late String userId = "01";
  late String userNickName = "user_1";
  late String password;
  late String address = "경기도 안양시 동안구";
}

class ContentsRepository {
  Map<String, dynamic> datas = {
    "sell": [
      {},
    ],
    "buy": [
      {},
    ],
    "rental": [
      {},
    ]
  };

  Future<void> loadData() async {
    var url = Uri.parse('https://ubuntu.i4624.tk/json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      datas = Map<String, List<Map<String, dynamic>>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)).map(
          (key, value) => MapEntry<String, List<Map<String, dynamic>>>(
            key,
            List<Map<String, dynamic>>.from(
              value.map(
                (item) => Map<String, dynamic>.from(item),
              ),
            ),
          ),
        ),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> loadContentsFromLocation(
      String location) async {
    await loadData();
    return datas[location]!;
  }
}
