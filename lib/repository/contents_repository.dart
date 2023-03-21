import 'dart:convert';
import 'package:http/http.dart' as http;

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
    print(datas);
    return datas[location]!;
  }
}
