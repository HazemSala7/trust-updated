import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_maintanence_request/add_maintanence_request.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_warranty/add_warranty.dart';
import 'package:trust_app_updated/Pages/merchant_screen/driver_screen/Warantty_Card/Warantty_Card.dart';
import 'package:trust_app_updated/Pages/merchant_screen/driver_screen/report_table/report_table.dart';
import 'package:trust_app_updated/Pages/merchant_screen/driver_screen/sort_dialog/sort_dialog.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';

import '../../../Components/button_widget/button_widget.dart';
import '../../../Components/drawer_widget/drawer_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Constants/constants.dart';
import '../../home_screen/home_screen.dart';
import '../../point_of_sales/google_map_view/google_map_view.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  String FromDate = "";
  String EndDate = "";
  String selectedStatus = "pending";
  String selectedSortCriteria = "very_late";
  String selectedcategory = "all";
  String countryID = "-1";

  void shoeSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xffFFFAF3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SortDialog(
          initialFromDate: FromDate,
          initialEndDate: EndDate,
          initialCountryID: countryID,
          initialSelectedStatus: selectedStatus,
          initialSelectedCategory: selectedcategory,
          AllCountries: AllCountries,
          initialSelectedSortCriteria: selectedSortCriteria,
          DoneStatus: DoneStatus,
          PendingStatus: PendingStatus,
          onSortSelected: (_fromDate, _endDate, _countryID, _selectedStatus,
              _selectedCategory, _selectedSortCrit) {
            setState(() {
              _page = 1;
              FromDate = _fromDate;
              EndDate = _endDate;
              countryID = _countryID;
              selectedStatus = _selectedStatus;
              selectedCity = _selectedCategory;
              selectedcategory = _selectedCategory;
              selectedSortCriteria = _selectedSortCrit;
            });
            _firstLoad();
          },
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  TextEditingController SearchController = TextEditingController();
  String selectedCity = "all";
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
                    InkWell(
                      onTap: () {
                        _scaffoldState.currentState?.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/images/iCons/Menu.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.maintenance_requests,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                    Container(
                      width: 20,
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                                bool allPending = warrantiesCard.every(
                                    (card) => card["mainStatus"] == "pending");

                                bool allDone = warrantiesCard.every(
                                    (card) => card["mainStatus"] == "done");

                                if (allPending) {
                                  statusValue = "in_progress";
                                } else if (allDone) {
                                  statusValue = "delivered";
                                } else {
                                  statusValue =
                                      ""; // Or any other default value
                                }

                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Center(
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Material(
                                            color: Color.fromARGB(198, 0, 0, 0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .edit,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
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
                                                        statusValue =
                                                            "in_progress";
                                                      });
                                                    },
                                                    BorderRaduis: 40,
                                                    ButtonColor: statusValue ==
                                                            "in_progress"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                    NameColor: statusValue ==
                                                            "in_progress"
                                                        ? Colors.black
                                                        : MAIN_COLOR,
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
                                                        statusValue =
                                                            "delivered";
                                                      });
                                                    },
                                                    BorderRaduis: 40,
                                                    ButtonColor: statusValue ==
                                                            "delivered"
                                                        ? MAIN_COLOR
                                                        : Colors.white,
                                                    NameColor: statusValue ==
                                                            "delivered"
                                                        ? Colors.black
                                                        : MAIN_COLOR,
                                                  ),
                                                  SizedBox(height: 15),
                                                  ButtonWidget(
                                                    name: AppLocalizations.of(
                                                            context)!
                                                        .save_date,
                                                    height: 30,
                                                    width: 90,
                                                    BorderColor: MAIN_COLOR,
                                                    FontSize: 12,
                                                    OnClickFunction: () async {
                                                      var warrantiesCardsFinal =
                                                          [];

                                                      for (int i = 0;
                                                          i <
                                                              warrantiesCard
                                                                  .length;
                                                          i++) {
                                                        if (warrantiesCard[i]
                                                                    ["status"]
                                                                .toString() ==
                                                            "true") {
                                                          warrantiesCardsFinal
                                                              .add({
                                                            "status":
                                                                statusValue
                                                                    .toString(),
                                                            "id":
                                                                warrantiesCard[
                                                                    i]["id"]
                                                          });
                                                        }
                                                      }
                                                      _page = 1;

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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            NavigatorFunction(context, ReportTable());
                          },
                          child: Image.asset(
                            "assets/images/iCons/Scd.png",
                            height: 25,
                            width: 25,
                            color: MAIN_COLOR,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () => shoeSortBottomSheet(context),
                          child: Image.asset(
                            "assets/images/iCons/Filter.png",
                            height: 35,
                            width: 35,
                            color: MAIN_COLOR,
                          ),
                        ),
                      ],
                    )
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
                              padding: const EdgeInsets.only(top: 150),
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
                                      cacheExtent: 500,
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
                                                  showCost: false,
                                                  index: index,
                                                  showMore: false,
                                                  reload: () {
                                                    _page = 1;
                                                    _firstLoad();

                                                    setState(() {});
                                                  },
                                                  customerName: AllProducts[
                                                              index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index][
                                                                  "merchant"] ==
                                                              null
                                                          ? "-"
                                                          : AllProducts[index]
                                                                  ["merchant"]
                                                              ["name"]
                                                      : "-",
                                                  merchantLocation: AllProducts[
                                                              index]
                                                          .containsKey(
                                                              "country")
                                                      ? AllProducts[index]
                                                                  ["country"] ==
                                                              null
                                                          ? "-"
                                                          : AllProducts[index]
                                                                  ["country"]
                                                              ["name"]
                                                      : "-",
                                                  latitude: AllProducts[index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index][
                                                                  "merchant"] ==
                                                              null
                                                          ? 0.0
                                                          : AllProducts[index]
                                                                  ["merchant"][
                                                              "coordinates"]["y"]
                                                      : 0.0,
                                                  cost: AllProducts[index]
                                                          ["maintenanceCost"] ??
                                                      0,
                                                  longitude: AllProducts[index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index][
                                                                  "merchant"] ==
                                                              null
                                                          ? 0.0
                                                          : AllProducts[index]
                                                                  ["merchant"][
                                                              "coordinates"]["x"]
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
                                                  customerPhone: AllProducts[
                                                              index]
                                                          .containsKey(
                                                              "merchant")
                                                      ? AllProducts[index][
                                                                  "merchant"] ==
                                                              null
                                                          ? "-"
                                                          : AllProducts[index]
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

  int PendingStatus = 0;
  int DoneStatus = 0;
  var AllProducts;
  var AllCountries = [];
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
      var _products = await getMaintenanceRequestsFilterDriver(_page,
          countryID: countryID.toString() == "null"
              ? null
              : countryID.toString() == "-1"
                  ? null
                  : countryID.toString(),
          category: selectedCity == "all" ? null : selectedCity.toString(),
          endDate: EndDate.toString() == "" ? null : EndDate.toString(),
          fromDate: FromDate.toString() == "" ? null : FromDate.toString(),
          selectedStatus: selectedStatus.toString());

      if (_products != null &&
          _products["data"] != null &&
          _products["data"].isNotEmpty) {
        for (int i = 0; i < _products["data"].length; i++) {
          warrantiesCard.add({
            "status": false,
            "id": _products["data"][i]["id"],
            "mainStatus": _products["data"][i]["status"]
          });
        }

        setState(() {
          AllProducts = _products["data"];
          AllCountries = _products["countryCounts"];
          PendingStatus = _products["statusCounts"]["pending"] ?? 0;
          DoneStatus = _products["statusCounts"]["done"] ?? 0;
        });
      } else {
        setState(() {
          AllProducts = [];
          AllCountries = [];
          PendingStatus = 0;
          DoneStatus = 0;
        });

        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.no_products,
        );
      }
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
        var _products = await getMaintenanceRequestsFilterDriver(_page,
            countryID: countryID.toString() == "null"
                ? null
                : countryID.toString() == "-1"
                    ? null
                    : countryID.toString(),
            category: selectedCity == "all" ? null : selectedCity.toString(),
            endDate: EndDate.toString() == "" ? null : EndDate.toString(),
            fromDate: FromDate.toString() == "" ? null : FromDate.toString(),
            selectedStatus: selectedStatus.toString());

        if (_products != null &&
            _products["data"] != null &&
            _products["data"].isNotEmpty) {
          for (int i = 0; i < _products["data"].length; i++) {
            warrantiesCard.add({
              "status": false,
              "id": _products["data"][i]["id"],
              "mainStatus": _products["data"][i]["status"]
            });
          }

          setState(() {
            AllProducts.addAll(_products["data"]);
          });
        } else {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.no_products,
          );
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
