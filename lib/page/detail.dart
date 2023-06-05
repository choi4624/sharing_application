import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/page/home.dart';
import 'package:test_project/page/pin.dart';
import '../repository/contents_repository.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with TickerProviderStateMixin {
  ScrollController controller = ScrollController();
  double locationAlpha = 0;
  final ContentsRepository contentsRepository = ContentsRepository();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation _colorTween;
  late List<dynamic> imgList;
  late Size size;
  late String username;
  int _currentPage = 0;

  late String currentLocation;
  late String cabinetLocation;
  final Map<String, String> optionsTypeToString = {
    "setting": "PIN 설정",
    "unlock": "PIN 해제",
  };
  final Map<String, dynamic> cabinetNumberToString = {
    "default": "캐비넷 번호",
    "1": "1번 캐비넷",
    "2": "2번 캐비넷",
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    imgList = widget.data["imageList"];
    _currentPage = 0;
    cabinetLocation = "default";
    currentLocation = "setting";
    // _loadMyFavoriteContentState();
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('userId')!;
    return prefs.getString('userId');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: Colors.black),
    );
  }

  // appBar Widget 구현
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: _makeIcon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white.withAlpha(locationAlpha.toInt()),
      elevation: 0,
      actions: const [],
    );
  }

  Widget _imageSlider() {
    return SizedBox(
      height: size.width * 0.8,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            itemCount: widget.data["imageList"].length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.data["imageList"][index],
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      "assets/images/No_image.jpg",
                      width: 100,
                      height: 100,
                    );
                  },
                ),
              );
            },
            //enableInfiniteScroll: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(500)),
            child: Text(
              '${_currentPage + 1}/${widget.data["imageList"].length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.data['imageList'].length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.black //Colors.white
                        : Colors.grey
                            .withOpacity(0.4), //Colors.white.withOpacity(0.4),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _sellerInfo() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/images/user.png"),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["username"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(widget.data["location"]),
                ],
              ),
              // Expanded(
              //   child: ManorTemperature(manorTemp: 37.3),
              // )
            ],
          ),
        ),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            widget.data["title"],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${widget.data["itemCategory"]}", // ∙ ${widget.data["boardCreatedTime"]}", //category 추가 건의
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.data["content"],
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 15),
          // Row(
          //   children: [
          //     Text(
          //       "조회수 ∙ ${widget.data["boardHits"].toString()}",
          //       style: const TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(controller: controller, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _imageSlider(),
            _sellerInfo(),
            _line(),
            _contentDetail(),
            _line(),
            //_otherCellContents(),
          ],
        ),
      ),
    ]);
  }

  Widget _bottomBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      child: Row(
        children: [
          // 관심 목록(좋아요) 기능 -> 현재 구현 X
          // GestureDetector(
          //   onTap: () async {
          //     if (isMyFavoriteContent) {
          //       await contentsRepository
          //           .deleteMyFavoriteContent(widget.data["cid"]);
          //     } else {
          //       await contentsRepository.addMyFavoriteContent(widget.data);
          //     }
          //     setState(() {
          //       isMyFavoriteContent = !isMyFavoriteContent;
          //     });
          //     scaffoldKey.currentState.showSnackBar(SnackBar(
          //       duration: const Duration(milliseconds: 1000),
          //       content: Text(
          //           isMyFavoriteContent ? "관심목록에 추가됐어요." : "관심목록에서 제거됐어요."),
          //     ));
          //   },
          //   child: SvgPicture.asset(
          //     isMyFavoriteContent
          //         ? "assets/svg/heart_on.svg"
          //         : "assets/svg/heart_off.svg",
          //     width: 20,
          //     height: 20,
          //     color: const Color(0xfff08f4f),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          // 가격 표기
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Home().calcStringToWon(widget.data["price"].toString()),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 연락처 확인 버튼 -> 채팅 기능 구현 후 채팅 버튼으로 수정 예정
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      print('${widget.data}');
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 20, 0, 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.data["phoneNum"]}",
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              Center(
                                child: SizedBox(
                                  width: 250,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 132, 206, 243),
                                    ),
                                    child: const Text("확인"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 132, 206, 243),
                      ),
                      child: const Text(
                        "연락처",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // PIN 입력 페이지 이동 버튼
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PIN(
                                  data: widget.data,
                                )),
                      );
                      // await getUserId();
                      // if (widget.data['username'] == username) {
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PIN(
                      //               data: widget.data,
                      //             )),
                      //   );
                      // } else {
                      //   // ignore: use_build_context_synchronously
                      //   showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         contentPadding:
                      //             const EdgeInsets.fromLTRB(0, 20, 0, 5),
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10.0)),
                      //         content: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: const [
                      //             Text(
                      //               "게시글 작성자만",
                      //             ),
                      //             Text(
                      //               "PIN 등록 / 해제가 가능합니다.",
                      //             ),
                      //           ],
                      //         ),
                      //         actions: <Widget>[
                      //           Center(
                      //             child: SizedBox(
                      //               width: 250,
                      //               child: ElevatedButton(
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: const Color.fromARGB(
                      //                       255, 132, 206, 243),
                      //                 ),
                      //                 child: const Text("확인"),
                      //                 onPressed: () {
                      //                   Navigator.pop(context);
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 132, 206, 243),
                      ),
                      child: const Text(
                        "PIN 설정 / 해제",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox(
      height: 20,
    );
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
