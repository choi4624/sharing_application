import 'dart:convert';

import 'package:http/http.dart' as http;

// 유저 데이터를 저장하는 클래스
class UserInfo {
  static late String userId;
  late String password;
  static late String jwt;

  Map<String, dynamic> toJson() {
    return {
      'username': userId,
      //'name': name,
    };
  }
}

// 서버로 부터 받은 게시글 데이터를 다루는 클래스
class ContentsRepository {
  //서버를 통해 받는 게시글 데이터의 원본을 저장하는 변수
  Map<String, dynamic> originBoardDatas = {};
  //게시글 구현을 위한 변환 데이터를 저장할 변수
  Map<String, List<Map<String, dynamic>>> mainBoardDatas = {};
  Map<String, List<Map<String, dynamic>>> recentmainBoardDatas = {};
  // 중계기 위치를 나타나낸 변수
  Map<String, dynamic> repeaterLocation = {
    'image': '',
    'title': '경기대학교 중계기',
    'location': '경기도 수원시 영통구 광교산로 154-42',
  };
  // 서버에서 게시글 데이터를 불러오는 함수
  Future<Map<String, dynamic>> loadData() async {
    var uri = Uri.parse('https://ubuntu.i4624.tk/api/v1/post/list');
    final headers = {'Authorization': 'Bearer ${UserInfo.jwt}'};
    final response = await http.get(
      uri,
      headers: headers,
    );
    //.timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      originBoardDatas = responseData;
      print(originBoardDatas);
      return responseData;
    } else {
      //print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> loadBoradData() async {
    try {
      originBoardDatas = await loadData();
      convertData(originBoardDatas);
      //print(originBoardDatas);
      print(mainBoardDatas);
    } catch (e) {
      print('Failed to load data: $e');
    }
    return originBoardDatas;
  }

// datas를 mainDatas로 변환시키는 함수
  Map<String, List<Map<String, dynamic>>> convertData(
      Map<String, dynamic> datas) {
    List<Map<String, dynamic>> postResponses =
        List<Map<String, dynamic>>.from(datas['postResponses']);
    postResponses.sort((a, b) => b['postid'].compareTo(a['postid']));

    for (var data in postResponses) {
      var category = data['boardCategory'];
      var productCategory = data['itemCategory'];
      var imageList = data['imageList'];
      var convertedProductCategory = '';
      var content = '';

      // 변환된 productCategory 값에 따라 카테고리를 설정
      if (productCategory == 'electronics') {
        convertedProductCategory = '디지털/전자';
      } else if (productCategory == 'tools') {
        convertedProductCategory = '공구';
      } else if (productCategory == 'clothes') {
        convertedProductCategory = '의류';
      } else if (productCategory == 'others') {
        convertedProductCategory = '기타';
      } else {
        convertedProductCategory = data['itemCategory'];
      }

      var imageUrls = imageList
          .map((imageId) =>
              'https://ubuntu.i4624.tk/image/imageid/${imageId['urid']}')
          .toList();

      if (data['content'] == null) {
        content = '내용이 없음';
      } else {
        content = data['content'];
      }

      var phoneNumber = data['phone'] as String;
      phoneNumber = phoneNumber
          .replaceFirstMapped(RegExp(r'^(\d{3})(\d{4})(\d{4})$'), (match) {
        return '${match[1]}-${match[2]}-${match[3]}';
      });

      var convertedData = {
        'postId': data['postid'],
        'username': data['username'],
        'title': data['title'],
        'location': data['location'],
        'price': data['price'],
        'content': content,
        'imageList': imageUrls,
        'itemCategory': convertedProductCategory,
        'phoneNum': phoneNumber,
      };

      if (mainBoardDatas.containsKey(category)) {
        mainBoardDatas[category]!.add(convertedData);
      } else {
        mainBoardDatas[category] = [convertedData];
      }
    }

    return mainBoardDatas;
  }

  Map<String, List<Map<String, dynamic>>> convertRecentData() {
    return recentmainBoardDatas;
  }

  Future<List<Map<String, dynamic>>> loadContentsFromLocation(
      String location) async {
    await loadBoradData();
    return mainBoardDatas[location]!;
  }

  Future<Map<String, dynamic>> loadRepeaterFromLocation() async {
    return repeaterLocation;
  }
}
