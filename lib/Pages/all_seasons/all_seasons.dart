import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/main.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/functions/functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllSeasons extends StatefulWidget {
  final name_ar, name_en, image;
  int id = 0;
  AllSeasons(
      {super.key,
      required this.name_ar,
      required this.name_en,
      required this.image,
      required this.id});

  @override
  State<AllSeasons> createState() => _AllSeasonsState();
}

class _AllSeasonsState extends State<AllSeasons> {
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
          body: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              isTablet = true;
            } else {
              isTablet = false;
            }
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
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Image.network(
                                  widget.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
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
                            locale.toString() == "ar"
                                ? widget.name_ar
                                : widget.name_en,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.view_by_category,
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
                              heightLoading: MediaQuery.of(context).size.height)
                          : sub_categories.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    "لا يوجد أي قسم",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )
                              : Expanded(
                                  child: AnimationLimiter(
                                    child: GridView.builder(
                                        cacheExtent: 500,
                                        controller: _controller,
                                        itemCount: sub_categories.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                          childAspectRatio:
                                              isTablet ? 2.3 : 1.2,
                                        ),
                                        itemBuilder: (context, int index) {
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
                                                      isTablet: isTablet,
                                                      url: sub_categories[index]
                                                          ["image"],
                                                      children: sub_categories[
                                                                  index]
                                                              ["children"] ??
                                                          0,
                                                      name_ar: sub_categories[index]
                                                                  ["translations"]
                                                              [0]["value"] ??
                                                          "",
                                                      name_en:
                                                          sub_categories[index]
                                                                  ["name"] ??
                                                              "",
                                                      id: sub_categories[index]
                                                          ["id"])),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                      // when the _loadMore function is running
                      if (_isLoadMoreRunning == true)
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child:
                              Center(child: LoadingWidget(heightLoading: 40)),
                        ),

                      // When nothing else to load
                      if (_hasNextPage == false)
                        Container(
                          padding: const EdgeInsets.only(top: 15, bottom: 20),
                          color: MAIN_COLOR,
                          child: const Center(
                            child: Text('لم يتبقى أي قسم'),
                          ),
                        ),
                    ],
                  ),
                ),
                AppBarWidget(logo: true)
              ],
            );
          }),
        ),
      ),
    );
  }

  var sub_categories;
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
      var _products = await getSubCategoriesBySeasonID(widget.id, _page);
      setState(() {
        sub_categories = _products;
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
        var _products = await getSubCategoriesBySeasonID(widget.id, _page);
        if (_products.isNotEmpty) {
          setState(() {
            sub_categories.addAll(_products);
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
