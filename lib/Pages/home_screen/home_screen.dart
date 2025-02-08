import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/bottom_bar_widget/bottom_bar_widget.dart';
import 'package:trust_app_updated/Components/drawer_widget/drawer_widget.dart';
import 'package:trust_app_updated/Pages/offers/offers.dart';

import '../../Components/category_widget/category_widget.dart';
import '../../Components/season_widget/season_widget.dart';
import '../../Components/slider_widget/slider_widget.dart';
import '../../Constants/constants.dart';
import '../../Language_Manager/language_manager.dart';
import '../../Models/slider/slider_model.dart';
import '../../Server/functions/functions.dart';
import '../new_products/new_products.dart';

class HomeScreen extends StatefulWidget {
  int currentIndex;
  HomeScreen({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero, () {
  //     _checkForUpdates();
  //   });
  // }

  // Future<void> _checkForUpdates() async {
  //   // final isUpdateAvailable = await checkForUpdate();

  //   // if (isUpdateAvailable) {
  //   _showUpdateDialog();
  //   // }
  // }

  // void _showUpdateDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Text(AppLocalizations.of(context)!.update_available),
  //         content: Text(AppLocalizations.of(context)!.new_version_desc),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(AppLocalizations.of(context)!.later),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               InAppUpdate.performImmediateUpdate();
  //             },
  //             child: Text(AppLocalizations.of(context)!.update),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  List<Widget> _pages = [NewProducts(), MainScreen(), Offers()];
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: MAIN_COLOR,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/images/iCons/Home.png",
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              onPressed: () => setState(() {
                widget.currentIndex = 1;
              }),
            ),
          ),
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.zero,
            notchMargin: 0,
            height: 65,
            shape: CircularNotchedRectangle(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: kBottomNavigationBarHeight,
              width: double.infinity,
              child: Container(
                width: double.infinity,
                child: BottomNavigationBar(
                    currentIndex: widget.currentIndex,
                    backgroundColor: Color(0xffECECEC),
                    selectedItemColor: MAIN_COLOR,
                    onTap: (index) {
                      setState(() {
                        widget.currentIndex = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/iCons/Offer.png"),
                            size: 31,
                          ),
                          label: AppLocalizations.of(context)!.offer),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                            size: 0,
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/iCons/New.png"),
                            size: 31,
                          ),
                          label: AppLocalizations.of(context)!.new_homepage)
                    ]),
              ),
            ),
          ),
          key: _scaffoldState,
          drawer: DrawerWell(
            Refresh: () {
              setState(() {});
            },
          ),
          body: _pages[widget.currentIndex],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  bool isTablet = false;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    hasInternet = await checkInternetConnection();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-full.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              isTablet = true;
            } else {
              isTablet = false;
            }
            return hasInternet == false
                ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      AppLocalizations.of(context)!.no_internet,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                : Column(
                    children: [
                      FutureBuilder(
                          future: getSliders(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 196, 196, 196),
                                  highlightColor:
                                      const Color.fromARGB(255, 129, 129, 129),
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              List<Silder>? album = [];
                              if (snapshot.data != null) {
                                List mysslide = snapshot.data;
                                List<Silder> album1 = mysslide.map((s) {
                                  Silder c = Silder.fromJson(s);
                                  return c;
                                }).toList();
                                album = album1;
                                return Container(
                                  width: double.infinity,
                                  height: isTablet
                                      ? MediaQuery.of(context).size.height * 0.3
                                      : MediaQuery.of(context).size.height *
                                          0.35,
                                  child: SlideImage(
                                    click: true,
                                    showShadow: true,
                                    slideimage: album,
                                  ),
                                );
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  color: Colors.white,
                                );
                              }
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 15, left: 15, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.view_by_category,
                              style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: getCategories(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  width: double.infinity,
                                  height: 170,
                                  child: ListView.builder(
                                      itemCount: 4,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 120,
                                            height: 150,
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 196, 196, 196),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 129, 129, 129),
                                              child: Container(
                                                width: 120,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                            } else {
                              if (snapshot.data != null) {
                                var categories = snapshot.data;
                                return isTablet
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CategoryWidget(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    height: 270,
                                                    name_ar: categories[0]
                                                                ["translations"]
                                                            [0]["value"] ??
                                                        "",
                                                    name_en: categories[0]
                                                            ["name"] ??
                                                        "",
                                                    id: categories[0]["id"] ??
                                                        0,
                                                    url: categories[0]
                                                            ["image"] ??
                                                        ""),
                                                CategoryWidget(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    height: 270,
                                                    name_ar: categories[1]
                                                                ["translations"]
                                                            [0]["value"] ??
                                                        "",
                                                    name_en: categories[1]
                                                            ["name"] ??
                                                        "",
                                                    id: categories[1]["id"] ??
                                                        0,
                                                    url: categories[1]
                                                            ["image"] ??
                                                        ""),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                CategoryWidget(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    height: 270,
                                                    name_ar: categories[2]
                                                                ["translations"]
                                                            [0]["value"] ??
                                                        "",
                                                    name_en: categories[2]
                                                            ["name"] ??
                                                        "",
                                                    id: categories[2]["id"] ??
                                                        0,
                                                    url: categories[2]
                                                            ["image"] ??
                                                        ""),
                                                CategoryWidget(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    height: 270,
                                                    name_ar: categories[3]
                                                                ["translations"]
                                                            [0]["value"] ??
                                                        "",
                                                    name_en: categories[3]
                                                            ["name"] ??
                                                        "",
                                                    id: categories[3]["id"] ??
                                                        0,
                                                    url: categories[3]
                                                            ["image"] ??
                                                        ""),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                        child: ListView.builder(
                                            itemCount: categories.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, int index) {
                                              return CategoryWidget(
                                                  width: 140,
                                                  height: 170,
                                                  name_ar: categories[index]
                                                              ["translations"]
                                                          [0]["value"] ??
                                                      "",
                                                  name_en: categories[index]
                                                          ["name"] ??
                                                      "",
                                                  id: categories[index]["id"] ??
                                                      0,
                                                  url: categories[index]
                                                          ["image"] ??
                                                      "");
                                            }),
                                      );
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  color: Colors.white,
                                );
                              }
                            }
                          }),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 15, left: 15),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.view_by_season,
                              style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: getSeasons(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: double.infinity,
                                height: 100,
                                child: ListView.builder(
                                    itemCount: 3,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: 90,
                                          height: 80,
                                          child: Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 196, 196, 196),
                                            highlightColor:
                                                const Color.fromARGB(
                                                    255, 129, 129, 129),
                                            child: Container(
                                              width: 90,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            } else {
                              if (snapshot.data != null) {
                                var seasons = snapshot.data;

                                return Container(
                                    width: double.infinity,
                                    height: 130,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SeasonWidget(
                                            height: isTablet ? 110 : 80,
                                            width: isTablet ? 130 : 90,
                                            name_ar: seasons[0]["translations"]
                                                    [0]["value"] ??
                                                "",
                                            name_en: seasons[0]["name"] ?? "",
                                            seasonImage: seasons[0]["cover"],
                                            id: seasons[0]["id"],
                                            image: SeasonsImages[0]),
                                        SeasonWidget(
                                            height: isTablet ? 110 : 80,
                                            width: isTablet ? 130 : 90,
                                            name_ar: seasons[1]["translations"]
                                                    [0]["value"] ??
                                                "",
                                            name_en: seasons[1]["name"] ?? "",
                                            seasonImage: seasons[1]["cover"],
                                            id: seasons[1]["id"],
                                            image: SeasonsImages[1]),
                                        SeasonWidget(
                                            height: isTablet ? 110 : 80,
                                            width: isTablet ? 130 : 90,
                                            name_ar: seasons[2]["translations"]
                                                    [0]["value"] ??
                                                "",
                                            name_en: seasons[2]["name"] ?? "",
                                            seasonImage: seasons[2]["cover"],
                                            id: seasons[2]["id"],
                                            image: SeasonsImages[2]),
                                      ],
                                    ));
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  color: Colors.white,
                                );
                              }
                            }
                          }),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  );
          })),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [AppBarWidget(logo: true)],
        )
      ],
    );
  }
}
