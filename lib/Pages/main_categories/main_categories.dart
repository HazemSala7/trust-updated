import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:trust_app_updated/Pages/products_by_season/products_by_season.dart';
import '../../Components/category_widget/category_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class MainCategories extends StatefulWidget {
  MainCategories({
    super.key,
  });

  @override
  State<MainCategories> createState() => _MainCategoriesState();
}

class _MainCategoriesState extends State<MainCategories> {
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
          body: Stack(
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
            
                  if (constraints.maxWidth >= 600) {
                    isTablet = true;
                  } else {
                    isTablet = false;
                  }

                  return SingleChildScrollView(
                    child: FutureBuilder(
                        future: getCatPage(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 196, 196, 196),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 129, 129, 129),
                                              child: Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
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
                                    Text(
                                      "Categories Page",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, right: 15, left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .view_by_category,
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
                                              border: Border.all(
                                                  color: Colors.black)),
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
                                FutureBuilder(
                                    future: getCategories(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return LoadingWidget(
                                          heightLoading: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                        );
                                      } else {
                                        if (snapshot.data != null) {
                                          var sub_categories = snapshot.data;

                                          return AnimationLimiter(
                                            child: GridView.builder(
                                                cacheExtent: 100,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    sub_categories.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 2,
                                                  mainAxisSpacing: 6,
                                                  childAspectRatio: 1.3,
                                                ),
                                                itemBuilder:
                                                    (context, int index) {
                                                  return AnimationConfiguration
                                                      .staggeredList(
                                                    position: index,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    child: SlideAnimation(
                                                      horizontalOffset: 100.0,
                                                      // verticalOffset: 100.0,
                                                      child: FadeInAnimation(
                                                          curve: Curves.easeOut,
                                                          child: SubCategoryWidget(
                                                              isTablet:
                                                                  isTablet,
                                                              url: sub_categories[index]
                                                                  ["image"],
                                                              children:
                                                                  sub_categories[index]["children"] ??
                                                                      0,
                                                              name_ar: sub_categories[index]
                                                                          ["translations"][0][
                                                                      "value"] ??
                                                                  "",
                                                              name_en: sub_categories[index]
                                                                      [
                                                                      "name"] ??
                                                                  "",
                                                              id: sub_categories[index]
                                                                  ["id"])),
                                                    ),
                                                  );
                                                }),
                                          );
                                        } else {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            width: double.infinity,
                                            color: Colors.white,
                                          );
                                        }
                                      }
                                    })
                              ],
                            );
                          } else {
                            if (snapshot.data != null) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: Image.network(
                                              "${URLIMAGE + '/' + snapshot.data["cover"]}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color.fromARGB(
                                                        183, 0, 0, 0),
                                                    Color.fromARGB(45, 0, 0, 0)
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .categories_page,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 15, left: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .view_by_category,
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
                                                border: Border.all(
                                                    color: Colors.black)),
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
                                  FutureBuilder(
                                      future: getCategories(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return LoadingWidget(
                                            heightLoading:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                          );
                                        } else {
                                          if (snapshot.data != null) {
                                            var sub_categories = snapshot.data;
                                            

                                            return AnimationLimiter(
                                              child: GridView.builder(
                                                  cacheExtent: 50,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      sub_categories.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 2,
                                                    mainAxisSpacing: 6,
                                                    childAspectRatio:
                                                        isTablet ? 1.2 : 0.96,
                                                  ),
                                                  itemBuilder:
                                                      (context, int index) {
                                                    return AnimationConfiguration
                                                        .staggeredList(
                                                      position: index,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      child: SlideAnimation(
                                                        horizontalOffset: 100.0,
                                                        // verticalOffset: 100.0,
                                                        child: FadeInAnimation(
                                                            curve:
                                                                Curves.easeOut,
                                                            child: CategoryWidget(
                                                                width: double
                                                                    .infinity,
                                                                height: isTablet
                                                                    ? 350
                                                                    : 200,
                                                                url: sub_categories[index]
                                                                    ["image"],
                                                                name_ar: sub_categories[index]
                                                                            ["translations"][0]
                                                                        [
                                                                        "value"] ??
                                                                    "",
                                                                name_en:
                                                                    sub_categories[index]["name"] ??
                                                                        "",
                                                                id: sub_categories[
                                                                        index]
                                                                    ["id"])),
                                                      ),
                                                    );
                                                  }),
                                            );
                                          } else {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              width: double.infinity,
                                              color: Colors.white,
                                            );
                                          }
                                        }
                                      })
                                ],
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
                  );
                }),
              ),
              AppBarWidget(logo: true)
            ],
          ),
        ),
      ),
    );
  }
}
