import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Components/button_widget/button_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'google_map_view/google_map_view.dart';
import 'map_with_markers/map_with_markers.dart';

class PointOfSales extends StatefulWidget {
  const PointOfSales({super.key});

  @override
  State<PointOfSales> createState() => _PointOfSalesState();
}

class _PointOfSalesState extends State<PointOfSales> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.poin_of_sales,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ButtonWidget(
                      BorderColor: MAIN_COLOR,
                      BorderRaduis: 10,
                      ButtonColor: MAIN_COLOR,
                      FontSize: 18,
                      NameColor: Colors.white,
                      OnClickFunction: () {
                        NavigatorFunction(
                            context, MapWithMarkers(merchants: AllProducts));
                      },
                      height: 50,
                      name:
                          AppLocalizations.of(context)!.show_merchants_location,
                      width: 300,
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
                                "لا يوجد أي منتج",
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
                                              child: merchantCard(
                                                name: AllProducts[index]
                                                    ["name"],
                                                lattitude: AllProducts[index]
                                                            ["coordinates"] !=
                                                        null
                                                    ? AllProducts[index]
                                                                ["coordinates"]
                                                            ["y"] ??
                                                        0.0
                                                    : 0.0,
                                                longituide: AllProducts[index]
                                                            ["coordinates"] !=
                                                        null
                                                    ? AllProducts[index]
                                                                ["coordinates"]
                                                            ["x"] ??
                                                        0.0
                                                    : 0.0,
                                                address: AllProducts[index]
                                                    ["address"],
                                                phone: AllProducts[index]
                                                    ["phoneNumber"],
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

  Widget merchantCard(
      {String address = "",
      String phone = "",
      int id = 0,
      String name = "",
      double lattitude = 0.0,
      double longituide = 0.0}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
      child: InkWell(
        onTap: () {
          NavigatorFunction(
              context,
              GoogleMapView(
                latt: lattitude,
                long: longituide,
              ));
        },
        child: Container(
          width: double.infinity,
          // height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffF1F1F1),
                                shape: BoxShape.circle),
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Icon(
                                Icons.store,
                                color: MAIN_COLOR,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            name.toString().length > 20
                                ? name.toString().substring(0, 20)
                                : name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                      Text(
                        phone,
                        style: TextStyle(color: Color(0xff999999)),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Text(
                          address,
                          style: TextStyle(color: Color(0xff666666)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
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
  double lattitude = 0.0;
  double longitude = 0.0;
  bool _locationPermissionGranted = false;

  getLocation() async {
    setState(() {
      _isFirstLoadRunning =
          true; // Show loading indicator while obtaining location
    });
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle if permission is denied
        setState(() {
          _isFirstLoadRunning = false; // Hide loading indicator
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "تم رفض الحصول على خاصية الموقع الجغرافي",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? country = placemark[0].country;
      lattitude = position.latitude;
      longitude = position.longitude;
      setState(() {
        _locationPermissionGranted = true;
      });
      // Call _firstLoad() only after obtaining location
      _firstLoad();
    } catch (e) {
      lattitude = 31.557588;
      longitude = 35.113145;
      _firstLoad();
      // Fluttertoast.showToast(
      //     msg: "تم رفض الحصول على خاصية الموقع الجغرافي",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

  void _firstLoad() async {
    try {
      var _products =
          await getMerchants(_page, lattitude.toString(), longitude.toString());
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
        var _products = await getMerchants(
            _page, lattitude.toString(), longitude.toString());
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
    getLocation();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }
}
