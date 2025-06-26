import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Components/product_widget/product_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class NewProducts extends StatefulWidget {
  NewProducts({super.key});

  @override
  State<NewProducts> createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool isTablet = false;
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BackGround.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              isTablet = true;
            } else {
              isTablet = false;
            }
            return Column(
              children: [
                _isFirstLoadRunning
                    ? LoadingWidget(
                        heightLoading: MediaQuery.of(context).size.height * 0.9)
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.28,
                                      child: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        List<String> images = json
                                            .decode(AllProducts[0]["image"])
                                            .cast<String>()
                                            .toList();

                                        return Stack(
                                          children: [
                                            ImageSlideshow(
                                              width: double.infinity,
                                              indicatorColor: Colors.red,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28,
                                              children: images
                                                  .map(
                                                    (e) => Image.network(
                                                        URLIMAGE + e,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                              "assets/images/logo_red.png",
                                                              fit: BoxFit.cover,
                                                            )),
                                                  )
                                                  .toList(),
                                              autoPlayInterval: 3000,
                                              isLoop: true,
                                            ),
                                            Container(
                                                width: double.infinity,
                                                height: 220,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          183, 0, 0, 0),
                                                      Color.fromARGB(
                                                          45, 0, 0, 0)
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        );
                                      })),
                                  Text(
                                    AllProducts[0]["name"] ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       right: 15, left: 15, top: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         AppLocalizations.of(context)!
                              //             .more_products,
                              //         style: TextStyle(
                              //             color: MAIN_COLOR,
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              if (!_isFirstLoadRunning)
                                if (AllProducts.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      "لا يوجد أي منتج",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )
                                else
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    cacheExtent: 500,
                                    itemCount: AllProducts.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6,
                                      childAspectRatio: isTablet ? 1.6 : 0.8,
                                    ),
                                    itemBuilder: (context, int index) {
                                      var imageRaw =
                                          AllProducts[index]["image"];
                                      String imageString =
                                          imageRaw is String ? imageRaw : "";
                                      List<String> resultList = [];

                                      if (imageString.isNotEmpty) {
                                        if (imageString.startsWith("[") &&
                                            imageString.endsWith("]")) {
                                          try {
                                            resultList = (jsonDecode(
                                                    imageString) as List)
                                                .map((item) => item.toString())
                                                .toList();
                                          } catch (e) {
                                            resultList = [];
                                          }
                                        }
                                      }

                                      List<String> _initSizes = [];
                                      List<String> _initSizesAR = [];
                                      List<int> _initSizesIDs = [];
                                      for (int i = 0;
                                          i <
                                              AllProducts[index]["sizes"]
                                                  .length;
                                          i++) {
                                        _initSizes.add(AllProducts[index]
                                                ["sizes"][i]["title"]
                                            .toString());
                                        _initSizesAR.add(AllProducts[index]
                                                    ["sizes"][i]["translations"]
                                                [0]["value"]
                                            .toString());
                                        _initSizesIDs.add(AllProducts[index]
                                            ["sizes"][i]["id"]);
                                      }

                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                          horizontalOffset: 100.0,
                                          child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              child: ProductWidget(
                                                  SIZESIDs: _initSizesIDs,
                                                  colors: AllProducts[index]
                                                          ["colors"] ??
                                                      [],
                                                  SIZES_EN: _initSizes,
                                                  SIZES_AR: _initSizesAR,
                                                  category_id: AllProducts[index]
                                                          ["categoryId"] ??
                                                      0,
                                                  image: resultList.isNotEmpty
                                                      ? resultList[0]
                                                      : "",
                                                  name_ar: AllProducts[index]
                                                              ["translations"]
                                                          [0]["value"] ??
                                                      "",
                                                  name_en: AllProducts[index]
                                                          ["name"] ??
                                                      "",
                                                  id: AllProducts[index]
                                                          ["id"] ??
                                                      0)),
                                        ),
                                      );
                                    },
                                  ),
                              if (_isLoadMoreRunning)
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 85),
                                    child: LoadingWidget(heightLoading: 50))
                            ],
                          ),
                        ),
                      ),
              ],
            );
          }),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [AppBarWidget(logo: true)],
        )
      ],
    );
  }

  var AllProducts;
  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;
  // There is next page or not
  bool _hasNextPage = true;
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var _products = await getLatestProducts(_page);
      setState(() {
        AllProducts = _products;
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        var _products = await getLatestProducts(_page);
        if (_products.isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products);
          });
        } else {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.no_products);
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  ScrollController? _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }
}
