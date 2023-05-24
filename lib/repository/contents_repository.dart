import 'dart:convert';

import 'package:http/http.dart' as http;

class UserInfo {
  static late String userId;
  late String name = "홍길동";
  late String password;
  static late String jwt;

  Map<String, dynamic> toJson() {
    return {
      'username': userId,
      //'name': name,
    };
  }
}

class ContentsRepository {
  //서버를 통해 받는 게시글 데이터의 원본을 저장하는 변수
  Map<String, dynamic> originBoardDatas = {};
  //게시글 구현을 위한 변환 데이터를 저장할 변수
  Map<String, List<Map<String, dynamic>>> mainBoardDatas = {};
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
      //convertData(originBoardDatas);
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
      print(originBoardDatas);
      print(mainBoardDatas);
    } catch (e) {
      print('Failed to load data: $e');
    }
    return originBoardDatas;
  }

  // datas를 mainDatas로 변환시키는 함수
  Map<String, List<Map<String, dynamic>>> convertData(
      Map<String, dynamic> datas) {
    for (var data in datas['postResponses']) {
      var category = data['boardCategory'];
      var productCategory = data['itemCategory'];
      var imageList = data['imageList'];
      // 변환된 productCategory 값에 따라 카테고리를 설정
      var convertedProductCategory = '';
      var content = '';
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
      //imageUrls ??= 'https://ubuntu.i4624.tk/image/imageid/3';
      if (data['content'] == null) {
        content = '내용이 없음';
      } else {
        content = data['content'];
      }
      var convertedData = {
        'username': data['username'],
        'title': data['title'],
        'location': data['location'],
        'price': data['price'],
        'content': content,
        'imageList': imageUrls,
        'itemCategory': convertedProductCategory,
      };
      if (mainBoardDatas.containsKey(category)) {
        mainBoardDatas[category]!.add(convertedData);
      } else {
        mainBoardDatas[category] = [convertedData];
      }
    }
    print(datas['imageList']);
    return mainBoardDatas;
  }

  //========================= 테스트 데이터 ================================
  // List<Map<String, dynamic>> data = [
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "sell",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "sell",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "sell",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "buy",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "buy",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "buy",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "rental",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "rental",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "rental",
  //     "productCategory": "electronics",
  //   },
  //   {
  //     "username": "rkskek12",
  //     "title": "11111",
  //     "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //     "price": "2000",
  //     "content": 'dsadsad',
  //     "imageList": [100095, 100095],
  //     "category": "rental",
  //     "productCategory": "electronics",
  //   },
  // ];
  // Map<String, dynamic> datas = {
  //   "sell": [
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         // 'https://ubuntu.i4624.tk/image/imageid/100095',
  //         // 'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'assets/images/No_image.jpg',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //   ],
  //   "buy": [
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //   ],
  //   "rental": [
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //     {
  //       "username": "rkskek12",
  //       "title": "11111",
  //       "location": "ㅇㅇㅇ ㅇㅇㅇ ㅇㅇㅇ",
  //       "price": "2000",
  //       "content": 'dsadsad',
  //       "imageList": [
  //         'https://ubuntu.i4624.tk/image/imageid/100095',
  //         'https://ubuntu.i4624.tk/image/imageid/100095'
  //       ],
  //       "productCategory": "디지털/가전",
  //     },
  //   ]
  // };
  //========================= 테스트 데이터 ================================
  Future<List<Map<String, dynamic>>> loadContentsFromLocation(
      String location) async {
    await loadBoradData();
    return mainBoardDatas[location]!;
  }
}
