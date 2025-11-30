import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/product_widget/product_widget.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/functions/functions.dart';
import '../../main.dart';

class ProductsBySeason extends StatefulWidget {
  final name_ar, name_en, image, season_image;
  int season_id = 0;
  ProductsBySeason(
      {super.key,
      required this.name_ar,
      required this.name_en,
      required this.image,
      required this.season_image,
      required this.season_id});

  @override
  State<ProductsBySeason> createState() => _ProductsBySeasonState();
}

class _ProductsBySeasonState extends State<ProductsBySeason> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool isTablet = false;
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerWell(
            Refresh: () {
              setState(() {});
            },
          ),
          body: Container(
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

              return SingleChildScrollView(
                controller: _controller,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: Image.network(
                                    widget.season_image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(183, 0, 0, 0),
                                          Color.fromARGB(45, 0, 0, 0)
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.toString() == "ar"
                                    ? widget.name_ar
                                    : widget.name_en,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.toString() == "ar"
                                    ? widget.name_ar
                                    : widget.name_en,
                                style: TextStyle(
                                    color: MAIN_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  showFilterDialog(context);
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Icon(
                                    Icons.filter_list,
                                    color: Colors.black,
                                    size: 17,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        _isFirstLoadRunning
                            ? LoadingWidget(
                                heightLoading:
                                    MediaQuery.of(context).size.height * 0.4,
                              )
                            : AllProducts.length == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      AppLocalizations.of(context)!.empty_products,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    cacheExtent: 50,
                                    itemCount: AllProducts.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6,
                                      childAspectRatio: isTablet ? 1.2 : 0.8,
                                    ),
                                    itemBuilder: (context, int index) {
                                      var imageString =
                                          AllProducts[index]["image"];
                                      List<String> resultList = [];
                                      if (imageString.isNotEmpty &&
                                          imageString.startsWith("[") &&
                                          imageString.endsWith("]")) {
                                        resultList =
                                            (jsonDecode(imageString) as List)
                                                .map((item) => item as String)
                                                .toList();
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
                                              isTablet: isTablet,
                                              SIZESIDs: _initSizesIDs,
                                              image: resultList.isNotEmpty
                                                  ? resultList[0]
                                                  : "",
                                              SIZES_EN: _initSizes,
                                              SIZES_AR: _initSizesAR,
                                              name_ar: AllProducts[index]
                                                          ["translations"][0]
                                                      ["value"] ??
                                                  "",
                                              name_en: AllProducts[index]
                                                      ["name"] ??
                                                  "",
                                              colors: AllProducts[index]
                                                      ["colors"] ??
                                                  [],
                                              id: AllProducts[index]["id"] ?? 0,
                                              category_id: AllProducts[index]
                                                      ["categoryId"] ??
                                                  0,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        if (_isLoadMoreRunning)
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                                child: LoadingWidget(
                              heightLoading: 40,
                            )),
                          ),
                      ],
                    ),
                    AppBarWidget(logo: true)
                  ],
                ),
              );
            }),
          ),
        ),
      ),
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
      var _products = await getProductsBySeasonID(widget.season_id, _page);
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
        var _products = await getProductsBySeasonID(widget.season_id, _page);
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
          print("error");
          print(err);
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
