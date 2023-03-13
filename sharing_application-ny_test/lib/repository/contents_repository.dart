class ContentsRepository {
  Map<String, dynamic> data = {}[{
    "image": "assets/images/ex1.png",
    "title": "제품명",
    "location": "경기도 안양시 동안구",
    "price": "30000",
    "like": "0",
  }];

  Future<List<Map<String, String>>> loadContentsFromLocation(
      String location) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return data[location];
  }
}
