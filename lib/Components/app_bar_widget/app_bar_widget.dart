import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Pages/cart/cart.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Pages/home_screen/home_screen.dart';
import '../../Pages/notifications/notifications.dart';
import '../search_dialog/search_dialog.dart';

class AppBarWidget extends StatefulWidget {
  bool logo = true, back = false, isHomePage = false;
  AppBarWidget({
    Key? key,
    required this.logo,
    this.back = false,
    this.isHomePage = false,
  }) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  String ROLEID = "";
  bool LOGIN = false;
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
    // TODO: implement initState
    super.initState();
    setControolers();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // IconButton(
                  //     onPressed: () {
                  //       Scaffold.of(context).openDrawer();
                  //     },
                  //     icon: Icon(
                  //       Icons.menu,
                  //       color: Colors.white,
                  //       size: 25,
                  //     )),
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: SvgPicture.asset(
                      "assets/images/iCons/Menu.svg",
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Visibility(
                    visible: widget.back,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Visibility(
                      visible: LOGIN,
                      child: Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                NavigatorFunction(context, Notifications());
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 20,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                    Visibility(
                        visible: ROLEID.toString() == "3" ? true : false,
                        child: SizedBox(
                          width: 15,
                        )),
                    Visibility(
                        visible: ROLEID.toString() == "3" ? true : false,
                        child: InkWell(
                          onTap: () {
                            NavigatorFunction(context, Cart());
                          },
                          child: FaIcon(
                            FontAwesomeIcons.cartShopping,
                            size: 20,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          widget.logo
              ? InkWell(
                  onTap: () {
                    if (!widget.isHomePage) {
                      NavigatorFunction(context, HomeScreen(currentIndex: 1));
                    }
                  },
                  child: Image.asset(
                    "assets/images/logo_white.png",
                    fit: BoxFit.fill,
                    width: 150,
                    height: 40,
                  ))
              : Text(
                  AppLocalizations.of(context)!.cart,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                )
        ],
      ),
    );
  }
}
