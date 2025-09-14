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
import 'package:trust_app_updated/l10n/app_localizations.dart';

import '../../../Components/button_widget/button_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Constants/constants.dart';
import '../../home_screen/home_screen.dart';
import '../../point_of_sales/google_map_view/google_map_view.dart';

class MaintenanceDepartment extends StatefulWidget {
  const MaintenanceDepartment({super.key});

  @override
  State<MaintenanceDepartment> createState() => _MaintenanceDepartmentState();
}

class _MaintenanceDepartmentState extends State<MaintenanceDepartment> {
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
                      "قسم الصيانة",
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            String statusValue = "";
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Center(
                                child: Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Material(
                                        color: Color.fromARGB(198, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .edit,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              ButtonWidget(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .pending,
                                                height: 40,
                                                width: double.infinity,
                                                BorderColor: MAIN_COLOR,
                                                FontSize: 18,
                                                OnClickFunction: () {
                                                  setState(() {
                                                    statusValue = "pending";
                                                  });
                                                },
                                                BorderRaduis: 40,
                                                ButtonColor:
                                                    statusValue == "pending"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                NameColor:
                                                    statusValue == "pending"
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              SizedBox(height: 15),
                                              ButtonWidget(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .in_progress,
                                                height: 40,
                                                width: double.infinity,
                                                BorderColor: MAIN_COLOR,
                                                FontSize: 18,
                                                OnClickFunction: () {
                                                  setState(() {
                                                    statusValue = "in_progress";
                                                  });
                                                },
                                                BorderRaduis: 40,
                                                ButtonColor:
                                                    statusValue == "in_progress"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                NameColor:
                                                    statusValue == "in_progress"
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              SizedBox(height: 15),
                                              ButtonWidget(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .done,
                                                height: 40,
                                                width: double.infinity,
                                                BorderColor: MAIN_COLOR,
                                                FontSize: 18,
                                                OnClickFunction: () {
                                                  setState(() {
                                                    statusValue = "done";
                                                  });
                                                },
                                                BorderRaduis: 40,
                                                ButtonColor:
                                                    statusValue == "done"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                NameColor: statusValue == "done"
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              SizedBox(height: 15),
                                              ButtonWidget(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .delivered,
                                                height: 40,
                                                width: double.infinity,
                                                BorderColor: MAIN_COLOR,
                                                FontSize: 18,
                                                OnClickFunction: () {
                                                  setState(() {
                                                    statusValue = "delivered";
                                                  });
                                                },
                                                BorderRaduis: 40,
                                                ButtonColor:
                                                    statusValue == "delivered"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                NameColor:
                                                    statusValue == "delivered"
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              SizedBox(height: 20),
                                              ButtonWidget(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .save_date,
                                                height: 30,
                                                width: 90,
                                                BorderColor: MAIN_COLOR,
                                                FontSize: 12,
                                                OnClickFunction: () async {
                                                  var warrantiesCardsFinal = [];
                                                  for (int i = 0;
                                                      i < warrantiesCard.length;
                                                      i++) {
                                                    if (warrantiesCard[i]
                                                            ["status"] ==
                                                        true) {
                                                      warrantiesCardsFinal.add({
                                                        "status": statusValue
                                                            .toString(),
                                                        "id": warrantiesCard[i]
                                                            ["id"]
                                                      });
                                                    }
                                                  }

                                                  await editMaintanenceRequestStatusArray(
                                                      warrantiesCardsFinal,
                                                      context);
                                                  Navigator.pop(context);
                                                  _firstLoad();
                                                },
                                                BorderRaduis: 20,
                                                ButtonColor: MAIN_COLOR,
                                                NameColor: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.pencil,
                            color: MAIN_COLOR,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocalizations.of(context)!.edit_selected,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MAIN_COLOR,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
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
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: WarrantyCard(
                                                  showCost: true,
                                                  showMore: true,
                                                  index: index,
                                                  cost: AllProducts[index]
                                                          ["maintenanceCost"] ??
                                                      0,
                                                  reload: () {
                                                    _firstLoad();
                                                    setState(() {});
                                                  },
                                                  customerName:
                                                      AllProducts[index]
                                                              .containsKey(
                                                                  "merchant")
                                                          ? AllProducts[index]
                                                                  ["merchant"]
                                                              ["name"]
                                                          : "-",
                                                  latitude: AllProducts[index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index]
                                                              ["merchant"]
                                                          ["coordinates"]["y"]
                                                      : 0.0,
                                                  longitude: AllProducts[index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index]
                                                              ["merchant"]
                                                          ["coordinates"]["x"]
                                                      : 0.0,
                                                  productName:
                                                      AllProducts[index]
                                                              .containsKey(
                                                                  "product")
                                                          ? AllProducts[index]
                                                                  ["product"]
                                                              ["name"]
                                                          : "-",
                                                  id: AllProducts[index]["id"],
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
    warrantiesCard.clear();
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      var _products = selectedCity == "الجميع"
          ? await getMaintenanceRequests(_page)
          : selectedCity == "الخليل"
              ? await getMaintenanceRequestsFilter(_page, "hebron")
              : await getMaintenanceRequestsFilter(_page, "ramallah");
      for (int i = 0; i < _products["data"].length; i++) {
        warrantiesCard.add({"status": false, "id": _products["data"][i]["id"]});
      }
      setState(() {
        AllProducts = _products["data"];
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
            ? await getMaintenanceRequests(_page)
            : selectedCity == "الخليل"
                ? await getMaintenanceRequestsFilter(_page, "الخليل")
                : await getMaintenanceRequestsFilter(_page, "رام الله");

        if (_products.isNotEmpty) {
          for (int i = 0; i < _products.length; i++) {
            warrantiesCard.add({"status": false, "id": _products[i]["id"]});
          }

          setState(() {
            AllProducts.addAll(_products["data"]);
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

var warrantiesCard = [];
