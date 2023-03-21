import 'dart:convert';
import 'package:flutter/services.dart';

class ContentsRepository {
  // Map<String, dynamic> datas = {
  //   "sell": [
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "판매 제품 A",
  //       "location": "경기도 안양시 동안구",
  //       "price": "120000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "판매 제품 B",
  //       "location": "경기도 안양시 동안구",
  //       "price": "15000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "판매 제품 C",
  //       "location": "경기도 안양시 동안구",
  //       "price": "320000",
  //       "like": "0",
  //     },
  //   ],
  //   "buy": [
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "구매 제품 A",
  //       "location": "경기도 안양시 동안구",
  //       "price": "120000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "구매 제품 B",
  //       "location": "경기도 안양시 동안구",
  //       "price": "15000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "구매 제품 C",
  //       "location": "경기도 안양시 동안구",
  //       "price": "320000",
  //       "like": "0",
  //     },
  //   ],
  //   "rental": [
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "대여 제품 A",
  //       "location": "경기도 안양시 동안구",
  //       "price": "120000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "대여 제품 B",
  //       "location": "경기도 안양시 동안구",
  //       "price": "15000",
  //       "like": "0",
  //     },
  //     {
  //       "image": "assets/images/ex1.png",
  //       "title": "대여 제품 C",
  //       "location": "경기도 안양시 동안구",
  //       "price": "320000",
  //       "like": "0",
  //     },
  //   ]
  // };

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
    String jsonString = await rootBundle.loadString('assets/testData.json');
    datas = Map<String, List<Map<String, dynamic>>>.from(
      jsonDecode(jsonString).map(
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
  }

  Future<List<Map<String, dynamic>>> loadContentsFromLocation(
      String location) async {
    await loadData();
    return datas[location]!;
  }
}
