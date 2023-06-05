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
      title: PopupMenuButton<String>(
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
      backgroundColor: const Color.fromARGB(255, 192, 234, 255),
      elevation: 1.5,
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
    List<Map<String, dynamic>> responseData =
        await ContentsRepository().loadContentsFromLocation(currentLocation);
    return responseData;
  }

  Widget _makeDataList(List<Map<String, dynamic>>? datas) {
    int size = datas == null ? 0 : datas.length;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        // 이미지가 비었을 경우 빈 이미지를 구현하기 위한 코드
        if (datas[index]["imageList"].isEmpty) {
          datas[index]["imageList"] = [""];
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailContentView(data: datas[index]);
                },
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.network(
                    datas[index]["imageList"][0],
                    width: 100,
                    height: 100,
                    scale: 1,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        "assets/images/No_image.jpg",
                        width: 100,
                        height: 100,
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      // 이미지 로딩 중에 표시할 에셋
                      return Image.asset(
                        'assets/images/loading_placeholder.gif',
                        width: 100,
                        height: 100,
                        scale: 1,
                        fit: BoxFit.cover,
                      );
                    },
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
                          datas[index]["title"]!,
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
                        // 게시글의 조회수와 좋아요를 표시하는 기능 -> 구현 예정
                        // Expanded(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       const Icon(
                        //         Icons.remove_red_eye_outlined,
                        //         color: Color.fromARGB(255, 64, 64, 64),
                        //         size: 17,
                        //       ),
                        //       const SizedBox(
                        //         width: 5,
                        //       ),
                        //       // Text(
                        //       //   //datas[index]["like"].toString(),
                        //       //   datas[index]["boardHits"].toString(),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: datas!.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  // 제품 목록을 보여주는 body
  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("데이터를 불러올 수 없습니다."));
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }
          return const Center(child: Text("해당 거래방식에 대한 데이터가 없습니다."));
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
          child: _bodyWidget(),
        ),
      ),
    );
  }
}
