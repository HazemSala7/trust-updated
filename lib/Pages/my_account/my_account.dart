import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Pages/my_account/edit_name/edit_name.dart';
import 'package:trust_app_updated/Pages/my_account/my_orders/my_orders.dart';
import 'package:trust_app_updated/Pages/wishlists/wishlists.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/search_dialog/search_dialog.dart';
import '../../Constants/constants.dart';
import '../home_screen/home_screen.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  String NAME = "";
  setSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString('name');
    setState(() {
      NAME = name.toString();
    });
  }

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSharedPref();
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Image.asset(
                "assets/images/logo_white.png",
                height: 25,
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
                image: AssetImage('assets/images/bg-full.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            NAME,
                            style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ContainerWidgetMyAccount(
                        AccountIcon: Icons.person,
                        myWidget: EditName(),
                        FirstName: AppLocalizations.of(context)!.profile,
                        LastName: AppLocalizations.of(context)!.edit_profile),
                    ContainerWidgetMyAccount(
                        AccountIcon: Icons.list,
                        myWidget: MyOrders(),
                        FirstName: AppLocalizations.of(context)!.order,
                        LastName: AppLocalizations.of(context)!.order),
                    ContainerWidgetMyAccount(
                        AccountIcon: Icons.favorite,
                        FirstName: AppLocalizations.of(context)!.favourite,
                        myWidget: Wishlists(),
                        LastName: AppLocalizations.of(context)!
                            .products_added_to_wishlists),
                    // ContainerWidgetMyAccount(
                    //     AccountIcon: Icons.password,
                    //     FirstName: AppLocalizations.of(context)!.password_my_account,
                    //     LastName: AppLocalizations.of(context)!.edit_password),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    actions: <Widget>[
                                      Container(
                                        width: 350,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "تحذير",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "هل تريد بالتأكيد حذف حسابك ?",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Center(
                                                              child: Text(
                                                                "الغاء",
                                                                style: TextStyle(
                                                                    color:
                                                                        MAIN_COLOR,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content:
                                                                      SizedBox(
                                                                    height: 60,
                                                                    width: 60,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        SpinKitFadingCircle(
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              40.0,
                                                                        ),
                                                                        Text(
                                                                          "Deleting Account",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                            final SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            String? user_ID =
                                                                await prefs
                                                                    .getString(
                                                                        'user_id');
                                                            deleteAccount(
                                                                user_ID,
                                                                context);
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Center(
                                                              child: Text(
                                                                "حذف",
                                                                style: TextStyle(
                                                                    color:
                                                                        MAIN_COLOR,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.delete_account,
                              style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    actions: <Widget>[
                                      Container(
                                        width: 350,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "تحذير",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .logoutsure,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Center(
                                                              child: Text(
                                                                "الغاء",
                                                                style: TextStyle(
                                                                    color:
                                                                        MAIN_COLOR,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            SharedPreferences
                                                                preferences =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            await preferences
                                                                .clear();
                                                            NavigatorFunction(
                                                                context,
                                                                HomeScreen(
                                                                    currentIndex:
                                                                        0));
                                                            Fluttertoast.showToast(
                                                                msg: AppLocalizations
                                                                        .of(
                                                                            context)!
                                                                    .toastlogout,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Center(
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .logout,
                                                                style: TextStyle(
                                                                    color:
                                                                        MAIN_COLOR,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.logout,
                              style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ContainerWidgetMyAccount(
      {IconData? AccountIcon,
      String FirstName = "",
      String LastName = "",
      required Widget myWidget}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          NavigatorFunction(context, myWidget);
        },
        child: Container(
          width: double.infinity,
          height: 50,
          color: Color.fromARGB(255, 241, 241, 241),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Icon(
                AccountIcon,
                color: Colors.black,
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FirstName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      LastName,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
