import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Pages/offers/offer_full_screen/offer_full_screen.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class Offers extends StatefulWidget {
  Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  var AllProducts;

  // The controller for the ListView
  ScrollController? _controller;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;

  // At the beginning, we fetch the first 20 posts
  int _page = 1;

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  Widget offerWidget({String name = "", String image = "", String desc = ""}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          NavigatorFunction(
              context,
              OfferFullScreen(
                name: name,
                image: image,
                desc: desc,
              ));
        },
        child: Container(
          width: double.infinity,
          height: 180,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 15,
                    child: Stack(children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            child: Image.network(
                              URLIMAGE + image,
                              fit: BoxFit.cover,
                              height: 155,
                              width: double.infinity,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            child: Container(
                                height: 155,
                                width: double.infinity,
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                            Text(
                              desc,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ])),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              NavigatorFunction(
                                  context,
                                  OfferFullScreen(
                                    name: name,
                                    image: image,
                                    desc: desc,
                                  ));
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var _products = await getOffers(_page);
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
        var _products = await getOffers(_page);
        if (_products.isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products["items"]);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-full.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _isFirstLoadRunning
                  ? LoadingWidget(
                      heightLoading: MediaQuery.of(context).size.height * 0.9)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              var images = [];
                              for (int i = 0; i < AllProducts.length; i++) {
                                var imageString = AllProducts[i]["image"];
                                if (AllProducts.isNotEmpty) {
                                  // Check if the imageString is in the expected format
                                  if (imageString != null &&
                                      imageString.startsWith("[") &&
                                      imageString.endsWith("]")) {
                                    // Remove square brackets and any surrounding double quotes
                                    imageString = imageString
                                        .substring(1, imageString.length - 1)
                                        .replaceAll('"', '');
                                  } else {
                                    imageString = "";
                                  }
                                }
                                images.add(imageString);
                              }

                              return Stack(
                                children: [
                                  ImageSlideshow(
                                    width: double.infinity,
                                    indicatorColor: Colors.red,
                                    height: 220,
                                    children: images
                                        .map(
                                          (e) => Image.network(URLIMAGE + e,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                    "assets/logo.png",
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
                                            Color.fromARGB(183, 0, 0, 0),
                                            Color.fromARGB(45, 0, 0, 0)
                                          ],
                                        ),
                                      )),
                                ],
                              );
                            })),
                        // Text(
                        //   AllProducts[0]["name"] ?? "",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //       fontSize: 18),
                        // )
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.more_products,
                      style: TextStyle(
                          color: MAIN_COLOR,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              _isFirstLoadRunning
                  ? Container()
                  : AllProducts.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "لا يوجد أي عرض , الرجاء المحاوله فيما بعد",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      : Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                                cacheExtent: 500,
                                controller: _controller,
                                itemCount: AllProducts.length,
                                itemBuilder: (context, int index) {
                                  var imageString = AllProducts[index]["image"];
                                  if (AllProducts.isNotEmpty) {
                                    // Check if the imageString is in the expected format
                                    if (imageString != null &&
                                        imageString.startsWith("[") &&
                                        imageString.endsWith("]")) {
                                      // Remove square brackets and any surrounding double quotes
                                      imageString = imageString
                                          .substring(1, imageString.length - 1)
                                          .replaceAll('"', '');
                                    } else {
                                      imageString = "";
                                    }
                                  }

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 100.0,
                                      // verticalOffset: 100.0,
                                      child: FadeInAnimation(
                                          curve: Curves.easeOut,
                                          child: offerWidget(
                                            image: imageString,
                                            desc: AllProducts[index]
                                                ["description"],
                                            name: AllProducts[index]["name"] ??
                                                "",
                                          )),
                                    ),
                                  );
                                }),
                          ),
                        ),
              // when the _loadMore function is running
              if (_isLoadMoreRunning == true)
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MAIN_COLOR,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [AppBarWidget(logo: true)],
        )
      ],
    );
  }
}
