import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Pages/my_account/my_orders/order_details/order_details.dart';
import 'package:trust_app_updated/Pages/wishlists/wishlists.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Components/search_dialog/search_dialog.dart';
import '../../../Constants/constants.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

int _currentIndex = 0;

class _MyOrdersState extends State<MyOrders> {
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
                AppLocalizations.of(context)!.my_orders,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            showSearchDialog(context);
                          },
                          icon: Icon(
                            Icons.search_outlined,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                _isFirstLoadRunning
                    ? LoadingWidget(
                        heightLoading: MediaQuery.of(context).size.height * 0.4,
                      )
                    : AllProducts.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "لا يوجد أي 'طلبية",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: ListView.builder(
                                      itemCount: AllProducts.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return OrderCard(
                                          date: AllProducts[index]
                                                  ["created_at"] ??
                                              "",
                                          id: AllProducts[index]["id"] ?? "",
                                          status: AllProducts[index]
                                                  ["status"] ??
                                              "",
                                        );
                                      }),
                                )),
                          ),
                // when the _loadMore function is running
                if (_isLoadMoreRunning == true)
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                        child: LoadingWidget(
                      heightLoading: 40,
                    )),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: MAIN_COLOR,
                    child: const Center(
                      child: Text('You have fetched all of the products'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget OrderCard({int id = 0, String status = "", String date = ""}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          NavigatorFunction(
              context,
              OrderDetails(
                orderID: id,
                status: status,
              ));
        },
        child: Container(
          width: double.infinity,
          height: 70,
          color: Color.fromARGB(255, 224, 223, 223),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.order_number} : ",
                            style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$id",
                            style: TextStyle(
                                color: Color.fromARGB(255, 35, 22, 221),
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.order_status} : ",
                            style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                                color: Color.fromARGB(255, 35, 22, 221),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  date.substring(0, 10),
                  style: TextStyle(
                      color: MAIN_COLOR,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
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

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var _products = await getOrders(_page);
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
        var _products = await getOrders(_page);
        if (_products.isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
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
