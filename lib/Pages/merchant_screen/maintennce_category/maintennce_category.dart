import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_maintanence_request/add_maintanence_request.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_warranty/add_warranty.dart';
import 'package:trust_app_updated/Pages/merchant_screen/driver_screen/Warantty_Card/Warantty_Card.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../Components/button_widget/button_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Constants/constants.dart';
import '../../home_screen/home_screen.dart';
import '../../point_of_sales/google_map_view/google_map_view.dart';

class MaintennceCategory extends StatefulWidget {
  const MaintennceCategory({super.key});

  @override
  State<MaintennceCategory> createState() => _MaintennceCategoryState();
}

class _MaintennceCategoryState extends State<MaintennceCategory> {
  @override
  TextEditingController SearchController = TextEditingController();
  String selectedCity = "الجميع";
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(color: MAIN_COLOR),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                    ),
                    Text(
                      AppLocalizations.of(context)!.maintenance_requests,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          NavigatorFunction(
                              context, HomeScreen(currentIndex: 0));
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!.toastlogout,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        icon: Icon(
                          Icons.logout,
                          size: 35,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ButtonWidget(
                        name: AppLocalizations.of(context)!.all,
                        height: 40,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        FontSize: 18,
                        OnClickFunction: () {
                          selectedCity = "الجميع";
                          AllProducts = [];
                          _page = 1;
                          _firstLoad();
                          setState(() {});
                        },
                        BorderRaduis: 40,
                        ButtonColor: selectedCity == "الجميع"
                            ? MAIN_COLOR
                            : Colors.white,
                        NameColor: selectedCity == "الجميع"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonWidget(
                        name: AppLocalizations.of(context)!.hebron,
                        height: 40,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        FontSize: 18,
                        OnClickFunction: () {
                          selectedCity = "الخليل";
                          _page = 1;
                          AllProducts = [];
                          _firstLoad();
                          setState(() {});
                        },
                        BorderRaduis: 40,
                        ButtonColor: selectedCity == "الخليل"
                            ? MAIN_COLOR
                            : Colors.white,
                        NameColor: selectedCity == "الخليل"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonWidget(
                        name: AppLocalizations.of(context)!.ramallah,
                        height: 40,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        FontSize: 18,
                        OnClickFunction: () {
                          selectedCity = "رام الله";
                          _page = 1;
                          AllProducts = [];
                          _firstLoad();
                          setState(() {});
                        },
                        BorderRaduis: 40,
                        ButtonColor: selectedCity == "رام الله"
                            ? MAIN_COLOR
                            : Colors.white,
                        NameColor: selectedCity == "رام الله"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              _isFirstLoadRunning
                  ? LoadingWidget(
                      heightLoading: MediaQuery.of(context).size.height * 0.7)
                  : no_internet
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            AppLocalizations.of(context)!.no_internet,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      : AllProducts.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                AppLocalizations.of(context)!.empty_maintencaes,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                      cacheExtent: 5000,
                                      controller: _controller,
                                      itemCount: AllProducts.length,
                                      itemBuilder: (context, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: SlideAnimation(
                                            horizontalOffset: 100.0,
                                            // verticalOffset: 100.0,
                                            child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              child: WarrantyCard(
                                                showCost: true,
                                                index: index,
                                                reload: () {
                                                  _firstLoad();
                                                  setState(() {});
                                                },
                                                customerName: AllProducts[index]
                                                        .containsKey("merchant")
                                                    ? AllProducts[index]
                                                        ["merchant"]["name"]
                                                    : "-",
                                                latitude: AllProducts[index]
                                                        .containsKey("merchant")
                                                    ? AllProducts[index]
                                                            ["merchant"]
                                                        ["coordinates"]["y"]
                                                    : 0.0,
                                                longitude: AllProducts[index]
                                                        .containsKey("merchant")
                                                    ? AllProducts[index]
                                                            ["merchant"]
                                                        ["coordinates"]["x"]
                                                    : 0.0,
                                                productName: AllProducts[index]
                                                        .containsKey("product")
                                                    ? AllProducts[index]
                                                        ["product"]["name"]
                                                    : "-",
                                                id: AllProducts[index]["id"],
                                                cost: AllProducts[index]
                                                        ["maintenanceCost"] ??
                                                    0,
                                                initialStatus:
                                                    AllProducts[index]
                                                        ["status"],
                                                malfunctionDescription:
                                                    AllProducts[index][
                                                            "malfunctionDdescription"] ??
                                                        "",
                                                notes: AllProducts[index]
                                                        ["notes"] ??
                                                    "",
                                                customerPhone:
                                                    AllProducts[index]
                                                            .containsKey(
                                                                "merchant")
                                                        ? AllProducts[index]
                                                                ["merchant"]
                                                            ["phoneNumber"]
                                                        : "-",
                                                warrantieStatus:
                                                    AllProducts[index]
                                                        ["warrantyStatus"],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
              // when the _loadMore function is running
              if (_isLoadMoreRunning == true)
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 85),
                    child: LoadingWidget(heightLoading: 50))
            ],
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

  bool no_internet = false;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      var _products = selectedCity == "الجميع"
          ? await getMaintenanceRequests(_page)
          : selectedCity == "الخليل"
              ? await getMaintenanceRequestsFilter(_page, "hebron")
              : await getMaintenanceRequestsFilter(_page, "ramallah");
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
        // Fetch data from the API
        var _products = await selectedCity == "الجميع"
            ? getMaintenanceRequests(_page)
            : selectedCity == "الخليل"
                ? getMaintenanceRequestsFilter(_page, "الخليل")
                : getMaintenanceRequestsFilter(_page, "رام الله");
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

  Map<String, List<dynamic>> cache = {};
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
