import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_maintanence_request/add_maintanence_request.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_warranty/add_warranty.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/main.dart';

import '../../../Components/button_widget/button_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Constants/constants.dart';

class MaintenanceRequests extends StatefulWidget {
  const MaintenanceRequests({super.key});

  @override
  State<MaintenanceRequests> createState() => _MaintenanceRequestsState();
}

class _MaintenanceRequestsState extends State<MaintenanceRequests> {
  @override
  TextEditingController SearchController = TextEditingController();
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_forward_outlined,
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
                    InkWell(
                      onTap: () {
                        NavigatorFunction(
                            context,
                            AddMaintanenceRequest(
                              prodSerialNumber: "",
                            ));
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.plus,
                            color: MAIN_COLOR,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .add_maintenance_request,
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
                  ? Container()
                  : Padding(
                      padding:
                          const EdgeInsets.only(right: 30, left: 30, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/wall-clock.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.pending}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      PendingStatus.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/processing-time.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.in_progress}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      InProgressStatus.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/done.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.done}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DoneStatus.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/delivered.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.delivered}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DeliveredStatus.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              // _isFirstLoadRunning
              //     ? LoadingWidget(
              //         heightLoading: MediaQuery.of(context).size.height * 0.7)
              //     : no_internet
              //         ? Padding(
              //             padding: const EdgeInsets.only(top: 150),
              //             child: Text(
              //               AppLocalizations.of(context)!.no_internet,
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 18),
              //             ),
              //           )
              //         : AllProducts.length == 0
              //             ? Padding(
              //                 padding: const EdgeInsets.only(top: 150),
              //                 child: Text(
              //                   AppLocalizations.of(context)!.empty_maintencaes,
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.bold, fontSize: 18),
              //                 ),
              //               )
              //             : Expanded(
              //                 child: Padding(
              //                   padding:
              //                       const EdgeInsets.only(right: 10, left: 10),
              //                   child: AnimationLimiter(
              //                     child: ListView.builder(
              //                         cacheExtent: 5000,
              //                         controller: _controller,
              //                         itemCount: AllProducts.length,
              //                         itemBuilder: (context, int index) {
              //                           return AnimationConfiguration
              //                               .staggeredList(
              //                             position: index,
              //                             duration:
              //                                 const Duration(milliseconds: 500),
              //                             child: SlideAnimation(
              //                               horizontalOffset: 100.0,
              //                               // verticalOffset: 100.0,
              //                               child: FadeInAnimation(
              //                                 curve: Curves.easeOut,
              //                                 child: warrantyCard(
              //                                   Reload: () {
              //                                     _firstLoad();
              //                                     setState(() {});
              //                                   },
              //                                   customerName: AllProducts[index]
              //                                       ["customerName"],
              //                                   status: AllProducts[index]
              //                                                   ["status"]
              //                                               .toString() ==
              //                                           "delivered"
              //                                       ? AppLocalizations.of(context)!
              //                                           .delivered
              //                                       : AllProducts[index]
              //                                                       ["status"]
              //                                                   .toString() ==
              //                                               "done"
              //                                           ? AppLocalizations
              //                                                   .of(context)!
              //                                               .done
              //                                           : AllProducts[index]
              //                                                           [
              //                                                           "status"]
              //                                                       .toString() ==
              //                                                   "pending"
              //                                               ? AppLocalizations.of(
              //                                                       context)!
              //                                                   .pending
              //                                               : AppLocalizations.of(
              //                                                       context)!
              //                                                   .in_progress,
              //                                   productName: AllProducts[index]
              //                                               ["product"] !=
              //                                           null
              //                                       ? locale.toString() == "ar"
              //                                           ? AllProducts[index]
              //                                                       ["product"]
              //                                                   ["translations"]
              //                                               [0]["value"]
              //                                           : AllProducts[index]
              //                                                       ["product"]
              //                                                   ["name"] ??
              //                                               ""
              //                                       : "-",
              //                                   id: AllProducts[index]["id"],
              //                                   malfunctionDdescription:
              //                                       AllProducts[index][
              //                                               "malfunctionDdescription"] ??
              //                                           "",
              //                                   notes: AllProducts[index]
              //                                           ["notes"] ??
              //                                       "",
              //                                   customerPhone:
              //                                       AllProducts[index]
              //                                           ["customerPhone"],
              //                                   warrantieStatus:
              //                                       AllProducts[index]
              //                                           ["warrantyStatus"],
              //                                 ),
              //                               ),
              //                             ),
              //                           );
              //                         }),
              //                   ),
              //                 ),
              //               ),
              // // when the _loadMore function is running
              // if (_isLoadMoreRunning == true)
              //   Padding(
              //       padding: EdgeInsets.only(top: 10, bottom: 85),
              //       child: LoadingWidget(heightLoading: 50))
            ],
          ),
        ),
      ),
    );
  }

  int DoneStatus = 0;
  int InProgressStatus = 0;
  int PendingStatus = 0;
  int DeliveredStatus = 0;
  Widget warrantyCard({
    bool warrantieStatus = true,
    String customerPhone = "",
    Function? Reload,
    String malfunctionDdescription = "",
    String notes = "",
    int id = 0,
    String customerName = "",
    String status = "",
    String productName = "",
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          // height: 150,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName.toString().length > 20
                                    ? customerName.toString().substring(0, 20)
                                    : customerName.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                productName.toString().length > 20
                                    ? productName.toString().substring(0, 20)
                                    : productName.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            TextEditingController CustomerNameController =
                                TextEditingController();
                            TextEditingController CustomerPhoneController =
                                TextEditingController();
                            TextEditingController DescriptionController =
                                TextEditingController();
                            TextEditingController NotesController =
                                TextEditingController();
                            CustomerNameController.text =
                                customerName.toString();
                            CustomerPhoneController.text =
                                customerPhone.toString();
                            NotesController.text = notes.toString();
                            DescriptionController.text =
                                malfunctionDdescription.toString();
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
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
                                                  AppLocalizations.of(context)!
                                                      .edit,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 20),
                                                Visibility(
                                                  visible: true,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 220,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .customer_name,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Container(
                                                          height: 50,
                                                          width: 220,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    9,
                                                                    9,
                                                                    9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: TextField(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            controller:
                                                                CustomerNameController,
                                                            obscureText: false,
                                                            maxLines: 50,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 220,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .customer_phone,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Container(
                                                          height: 50,
                                                          width: 220,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    9,
                                                                    9,
                                                                    9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: TextField(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            controller:
                                                                CustomerPhoneController,
                                                            obscureText: false,
                                                            maxLines: 50,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .notes,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        height: 100,
                                                        width: 220,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 9, 9, 9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          controller:
                                                              NotesController,
                                                          obscureText: false,
                                                          maxLines: 50,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .description,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        height: 100,
                                                        width: 220,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 9, 9, 9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          controller:
                                                              DescriptionController,
                                                          obscureText: false,
                                                          maxLines: 50,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ButtonWidget(
                                                    name: AppLocalizations.of(
                                                            context)!
                                                        .save_date,
                                                    height: 30,
                                                    width: 90,
                                                    BorderColor: MAIN_COLOR,
                                                    FontSize: 12,
                                                    OnClickFunction: () async {
                                                      await editMaintanenceRequest(
                                                          id,
                                                          CustomerPhoneController
                                                              .text,
                                                          CustomerNameController
                                                              .text,
                                                          NotesController.text,
                                                          DescriptionController
                                                              .text,
                                                          context);
                                                      Navigator.pop(context);
                                                      Reload!();
                                                    },
                                                    BorderRaduis: 20,
                                                    ButtonColor: MAIN_COLOR,
                                                    NameColor: Colors.white)
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
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
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

  bool no_internet = false;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      var _products = await getMaintenanceRequestsByMerchantID(_page);
      setState(() {
        if (_products != null && _products["data"] != null) {
          AllProducts = _products["data"];
          DoneStatus = _products["statusCounts"]["done"] ?? 0;
          PendingStatus = _products["statusCounts"]["pending"] ?? 0;
          InProgressStatus = _products["statusCounts"]["in_progress"] ?? 0;
          DeliveredStatus = _products["statusCounts"]["delivered"] ?? 0;
        } else {
          AllProducts = [];
          DoneStatus = 0;
          PendingStatus = 0;
          InProgressStatus = 0;
          DeliveredStatus = 0;
        }
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
        var _products = await getMaintenanceRequestsByMerchantID(_page);
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
