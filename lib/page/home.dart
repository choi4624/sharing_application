import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_project/page/detail.dart';
import 'package:test_project/repository/contents_repository.dart';

class Home extends StatefulWidget {
  Home({super.key});
  final oCcy = NumberFormat(
    "#,###",
    "ko_KR",
  );
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))}원";
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentLocation;

  //앱 내에서 좌측 상단바 출력을 위한 데이터
  final Map<String, String> optionsTypeToString = {
    "sell": "판매",
    "buy": "구매",
    "rental": "대여",
  };
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    currentLocation = "sell";
    isLoading = false;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("click event");
          ContentsRepository().loadData();
        },
        child: PopupMenuButton<String>(
          offset: const Offset(0, 30),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String value) {
            setState(() {
              currentLocation = value;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "sell",
                child: Text("판매"),
              ),
              const PopupMenuItem(
                value: "buy",
                child: Text("구매"),
              ),
              const PopupMenuItem(
                value: "rental",
                child: Text("대여"),
              ),
            ];
          },
          //좌측 상단 판매, 구매, 대여 선택바
          child: Row(
            children: [
              //앱 내에서 좌측 상단바 출력을 위한 데이터
              Text(
                optionsTypeToString[currentLocation]!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1, // 그림자를 표현되는 높이 3d 측면의 높이를 뜻함.
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // 원화 계산 라이브러리 & 원화 계산 함수
  final oCcy = NumberFormat(
    "#,###",
    "ko_KR",
  );
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))}원";
  }

  // currentLocation으로 판매, 구매, 대여 페이지 선택
  Future<List<Map<String, dynamic>>> _loadContents() async {
    ContentsRepository().loadData();
    List<Map<String, dynamic>> responseData =
        await ContentsRepository().loadContentsFromLocation(currentLocation);
    return responseData;
  }

  Widget _makeDataList(List<Map<String, dynamic>>? datas) {
    int size = datas == null ? 0 : datas.length;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  datas[index]["id"];
                  datas[index]["boardWriter"];
                  datas[index]["boardTitle"];
                  datas[index]["boardContents"];
                  datas[index]["location"];
                  datas[index]["price"];
                  datas[index]["boardHits"];
                  datas[index]["boardCreatedTime"];
                  datas[index]["boardUpdatedTime"];
                  datas[index]["boardCategory"];
                  datas[index]["image"];
                  //datas[index]["like"];
                  return DetailContentView(data: datas[index]);
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.asset(
                    UserInfo().defaultImage, //datas[index]["image"],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas[index]["boardTitle"]!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          datas[index]["location"]!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          calcStringToWon(datas[index]["price"].toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Color.fromARGB(255, 64, 64, 64),
                                size: 17,
                              ),
                              // SvgPicture.asset(
                              //   "assets/svg/heart_off.svg",
                              //   width: 13,
                              //   height: 13,
                              // ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                //datas[index]["like"].toString(),
                                datas[index]["boardHits"].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: datas!.length, // 상품 목록의 개수
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  // 제품 목록을 보여주는 body //원본 코드
  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("데이터 오류"));
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }
          return const Center(child: Text("해당 지역에 데이터가 없습니다."));
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _appbarWidget(),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _bodyWidget();
              });
            },
            child: _bodyWidget()),
      ),
    );
  }
}
