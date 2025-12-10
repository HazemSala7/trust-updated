import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/register_screen/register_screen.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_warranty/add_warranty.dart';
import 'package:trust_app_updated/Pages/merchant_screen/check_maintennance_request_by_customer_phone/check_maintennance_request_by_customer_phone.dart';
import 'package:trust_app_updated/Pages/merchant_screen/check_wrranties/check_wrranties.dart';
import 'package:trust_app_updated/Pages/merchant_screen/maintenance_requests/maintenance_requests.dart';
import 'package:trust_app_updated/Pages/merchant_screen/warranties/warranties.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../../Components/loading_widget/loading_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../authentication/login_screen/app_bar_login/app_bar_login.dart';
import '../home_screen/home_screen.dart';
import 'add_maintanence_request/add_maintanence_request.dart';
import 'check_maintennance_request/check_maintennance_request.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 45,
                        width: double.infinity,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo_red.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35, left: 35),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .effective_guarantees,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(context, Warranties());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .activate_warranty,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(context, AddWarranty());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .warranty_inspection,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(
                                        context, CheckWrranties());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .maintenance_requests,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(
                                        context, MaintenanceRequests());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .maintenance_status_product_id,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(
                                        context, CheckMaintennanceRequest());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            // Padding(
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .maintenance_status_customer_phone,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: Color(0xffEBEBEB),
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorPushFunction(context,
                                        CheckMaintennanceRequestByCustomerPhoneNumber());
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: Color(0xffEBEBEB),
                                  NameColor: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!.logout,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: MAIN_COLOR,
                                  FontSize: 16,
                                  OnClickFunction: () async {
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
                                  BorderRaduis: 40,
                                  ButtonColor: MAIN_COLOR,
                                  NameColor: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AppBarLogin(
                title: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
