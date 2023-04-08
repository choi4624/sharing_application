import 'package:flutter/material.dart';
import 'package:test_project/page/home.dart';
import '../repository/contents_repository.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with TickerProviderStateMixin {
  final ContentsRepository contentsRepository = ContentsRepository();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Size size;

  late List<String> imgList;
  late int _current;
  ScrollController controller = ScrollController();
  double locationAlpha = 0;
  late AnimationController _animationController;
  late Animation _colorTween;
  bool isMyFavoriteContent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    imgList = [
      //UserInfo().defaultImage,
      // widget.data["image"],
      // widget.data["image"],
      // widget.data["image"],
      // widget.data["image"],
      // widget.data["image"],
    ];
    _current = 0;
    // _loadMyFavoriteContentState();
    controller.addListener(() {
      setState(() {
        if (controller.offset > 255) {
          locationAlpha = 255;
        } else {
          locationAlpha = controller.offset;
        }

        _animationController.value = locationAlpha / 255;
      });
    });
  }

  // _loadMyFavoriteContentState() async {
  //   bool ck = await contentsRepository.isMyFavoriteContents(widget.data["cid"]);
  //   setState(() {
  //     isMyFavoriteContent = ck;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(icon, color: Colors.black));
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
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  // Widget _makeSliderImage() {
  //   return SizedBox(
  //     height: size.width * 0.8,
  //     child: Stack(
  //       children: [
  //         Hero(
  //           tag: widget.data["cid"],
  //           child: CarouselSlider(
  //             options: CarouselOptions(
  //                 height: size.width * 0.8,
  //                 initialPage: 0,
  //                 enableInfiniteScroll: false,
  //                 viewportFraction: 1.0,
  //                 enlargeCenterPage: false,
  //                 onPageChanged: (index, reason) {
  //                   setState(() {
  //                     _current = index;
  //                   });
  //                 }),
  //             items: imgList.map((i) {
  //               return Container(
  //                 width: size.width,
  //                 height: size.width,
  //                 color: Colors.red,
  //                 child: Image.asset(
  //                   widget.data["image"],
  //                   fit: BoxFit.cover,
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 0,
  //           left: 0,
  //           right: 0,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: List.generate(imgList.length, (index) {
  //               return Container(
  //                 width: 8.0,
  //                 height: 8.0,
  //                 margin: const EdgeInsets.symmetric(
  //                     vertical: 10.0, horizontal: 5.0),
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: _current == index
  //                       ? Colors.white
  //                       : Colors.white.withOpacity(0.4),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _sellerSimpleInfo() {
    return Column(
      children: [
        Image.asset(
          //widget.data["image"],
          UserInfo().defaultImage,
        ),
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
              // CircleAvatar(
              //   radius: 25,
              //   backgroundImage: Image.asset("assets/images/user.png").image,
              // ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["boardWriter"],
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
            widget.data["boardTitle"],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "디지털/가전 ∙ ${widget.data["boardCreatedTime"]}", //category 추가 건의
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.data["boardContents"],
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: Text(
              //     "관심 ∙ ${widget.data["like"].toString()}",
              //     style: const TextStyle(
              //       fontSize: 12,
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),
              Text(
                "조회수 ∙ ${widget.data["boardHits"].toString()}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "판매자님의 판매 상품",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "모두보기",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(controller: controller, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            //_makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            //_otherCellContents(),
          ],
        ),
      ),
      // SliverPadding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   sliver: SliverGrid(
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      //     delegate: SliverChildListDelegate(List.generate(20, (index) {
      //       return Container(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             ClipRRect(
      //               borderRadius: BorderRadius.circular(10),
      //               child: Container(
      //                 color: Colors.grey.withOpacity(0.3),
      //                 height: 120,
      //               ),
      //             ),
      //             const Text(
      //               "상품 제목",
      //               style: TextStyle(fontSize: 14),
      //             ),
      //             const Text(
      //               "금액",
      //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      //             ),
      //           ],
      //         ),
      //       );
      //     }).toList()),
      //   ),
      // ),
    ]);
  }

  Widget _bottomBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      //color: Colors.white,
      child: Row(
        children: [
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
            margin: const EdgeInsets.only(left: 15, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 132, 206, 243),
                  ),
                  child: const Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
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
