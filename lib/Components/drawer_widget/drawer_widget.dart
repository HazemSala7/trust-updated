import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Pages/about_us/about_us.dart';
import 'package:trust_app_updated/Pages/authentication/login_screen/login_screen.dart';
import 'package:trust_app_updated/Pages/contact_us/contact_us.dart';
import 'package:trust_app_updated/Pages/home_screen/home_screen.dart';
import 'package:trust_app_updated/Pages/main_categories/main_categories.dart';
import 'package:trust_app_updated/Pages/merchant_screen/maintenance_requests/maintenance_requests.dart';
import 'package:trust_app_updated/Pages/merchant_screen/warranties/warranties.dart';
import 'package:trust_app_updated/Pages/my_account/my_account.dart';
import 'package:trust_app_updated/Pages/my_account/my_orders/my_orders.dart';
import 'package:trust_app_updated/Pages/wishlists/wishlists.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Constants/constants.dart';
import '../../Pages/merchant_screen/driver_screen/driver_screen.dart';
import '../../Pages/merchant_screen/merchant_screen.dart';
import '../../Pages/point_of_sales/point_of_sales.dart';
import '../../main.dart';
import '../search_dialog/search_dialog.dart';

class DrawerWell extends StatefulWidget {
  Function Refresh;
  DrawerWell({
    Key? key,
    required this.Refresh,
  }) : super(key: key);

  @override
  State<DrawerWell> createState() => _DrawerWellState();
}

class _DrawerWellState extends State<DrawerWell> {
  @override
  bool LOGIN = false;
  String ROLEID = "";
  setControolers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = await prefs.getBool('login') ?? false;
    String? RoleID = await prefs.getString('role_id');
    if (login) {
      setState(() {
        LOGIN = true;
        ROLEID = RoleID.toString();
      });
    } else {
      setState(() {
        LOGIN = false;
        ROLEID = RoleID.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setControolers();
  }

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            // width: 100,
            child: Center(
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.cover,
                height: 70,
                // width: 100,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DrawerMethod(
              name: AppLocalizations.of(context)!.home,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(currentIndex: 1),
                    ),
                    (route) => false,
                  );
                }
              },
              icon: Icons.home,
              iconPath: "assets/images/home.svg"),
          DrawerMethod(
              name: AppLocalizations.of(context)!.product,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                NavigatorPushFunction(context, MainCategories());
              },
              icon: Icons.category_sharp,
              iconPath: "assets/images/products.svg"),
          DrawerMethod(
              name: AppLocalizations.of(context)!.poin_of_sales,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                NavigatorPushFunction(context, PointOfSales());
              },
              icon: Icons.category_sharp,
              iconPath: "assets/images/point_of_sales.svg"),
          Visibility(
            visible: ROLEID.toString() == "3" || ROLEID.toString() == "5"
                ? true
                : false,
            child: DrawerMethod(
                name: AppLocalizations.of(context)!.warranties_and_maintenances,
                OnCLICK: () {
                  Navigator.pop(context); // Close drawer first
                  if (ROLEID.toString() == "3") {
                    NavigatorPushFunction(context, MerchantScreen());
                  } else {
                    NavigatorPushFunction(context, DriverScreen());
                  }
                },
                icon: Icons.fmd_good,
                iconPath: "assets/images/maintences_warranties.svg"),
          ),
          DrawerMethod(
              name: AppLocalizations.of(context)!.contact,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                NavigatorPushFunction(context, ContactUs());
              },
              icon: Icons.phone,
              iconPath: "assets/images/contact.svg"),
          DrawerMethod(
              name: AppLocalizations.of(context)!.who,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                NavigatorPushFunction(context, AboutUs());
              },
              icon: Icons.question_mark,
              iconPath: "assets/images/about.svg"),
         DrawerMethod(
  name: AppLocalizations.of(context)!.download_catalog,
  OnCLICK: () {
    downloadAndOpenFile(
      context,
      "https://test.redtrust.ps/storage/pages/August2025/uVKKEL5i80Pq6zO78xxM.pdf",
      "catalog.pdf",
    );
  },
  icon: Icons.download,
  iconPath: "assets/images/download-svgrepo-com.svg",
),

          DrawerMethod(
              name: AppLocalizations.of(context)!.search_drawer,
              OnCLICK: () {
                showSearchDialog(context);
              },
              icon: Icons.search,
              iconPath: "assets/images/search.svg"),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: LOGIN,
            child: DrawerMethod(
                name: AppLocalizations.of(context)!.my_account,
                OnCLICK: () {
                  Navigator.pop(context); // Close drawer first
                  NavigatorPushFunction(context, MyAccount());
                },
                icon: Icons.account_box,
                iconPath: "assets/images/account.svg"),
          ),
          DrawerMethod(
              name: AppLocalizations.of(context)!.favourite,
              OnCLICK: () {
                Navigator.pop(context); // Close drawer first
                NavigatorPushFunction(context, Wishlists());
              },
              icon: Icons.favorite,
              iconPath: "assets/images/favorates.svg"),
          Visibility(
            visible: LOGIN,
            child: DrawerMethod(
                name: AppLocalizations.of(context)!.my_orders,
                OnCLICK: () {
                  Navigator.pop(context); // Close drawer first
                  NavigatorPushFunction(context, MyOrders());
                },
                icon: Icons.request_page,
                iconPath: "assets/images/orders.svg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: LOGIN ? false : true,
            child: DrawerMethod(
                name: AppLocalizations.of(context)!.login,
                OnCLICK: () {
                  NavigatorFunction(context, LoginScreen());
                },
                icon: Icons.login,
                iconPath: "assets/images/logout.svg"),
          ),
          // Visibility(
          //   visible: LOGIN ? false : true,
          //   child: DrawerMethod(
          //       name: AppLocalizations.of(context)!.create_account,
          //       OnCLICK: () {
          //         NavigatorFunction(context, RegisterScreen());
          //       },
          //       icon: Icons.app_registration),
          // ),
          Visibility(
            visible: LOGIN,
            child: DrawerMethod(
                name: AppLocalizations.of(context)!.logout,
                OnCLICK: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          AppLocalizations.of(context)!.logoutsure,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  await preferences.clear();
                                  NavigatorFunction(
                                      context, HomeScreen(currentIndex: 0));
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .toastlogout,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MAIN_COLOR),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.yes,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MAIN_COLOR),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.no,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                icon: Icons.logout,
                iconPath: "assets/images/logout.svg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    Trust.of(context)!
                        .setLocale(Locale.fromSubtags(languageCode: 'ar'));
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('language', "arabic");
                    widget.Refresh();
                  },
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromARGB(255, 99, 99, 99)),
                    child: Center(
                      child: Text(
                        "عربي",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Trust.of(context)!
                        .setLocale(Locale.fromSubtags(languageCode: 'en'));
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('language', "english");
                    widget.Refresh();
                  },
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color.fromARGB(255, 99, 99, 99)),
                    child: Center(
                      child: Text(
                        "English",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget DrawerMethod({
    String name = "",
    String iconPath = "",
    IconData? icon,
    Function? OnCLICK,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          if (OnCLICK != null) {
            OnCLICK();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                fit: BoxFit.cover,
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 15),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: name.length > 25 ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
