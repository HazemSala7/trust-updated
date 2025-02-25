import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/register_screen/register_screen.dart';
import 'package:trust_app_updated/Pages/merchant_screen/check_maintennance_request_by_customer_phone/check_maintennance_request_by_customer_phone.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';

import '../../../Components/loading_widget/loading_widget.dart';

class CheckMaintennanceRequest extends StatefulWidget {
  const CheckMaintennanceRequest({super.key});

  @override
  State<CheckMaintennanceRequest> createState() =>
      _CheckMaintennanceRequestState();
}

class _CheckMaintennanceRequestState extends State<CheckMaintennanceRequest> {
  @override
  TextEditingController productSerialNumberController = TextEditingController();
  String resultMessageWarrantStatus = "";
  String maintenceNotes = "";
  String maintenceStatus = "";
  var maintenceStatusTranslate = {
    "ar": {
      "pending": "بانتظار التوصيل للصيانة",
      "in_progress": "في الصيانة",
      "done": "تم الصيانة",
      "delivered": "تم التسليم للتاجر"
    },
    "en": {
      "pending": "Pending",
      "in_progress": "In Progress",
      "done": "Done",
      "delivered": "Delivered"
    }
  };
  String maintenceDesc = "";
  String productImage = "";
  String productName = "";
  String customerName = "";
  String customerPhone = "";
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.maintenance_status,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                  )),
            ),
          ),
          backgroundColor: Color(0xffF0F0F0),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: ButtonWidget(
                  //           name: AppLocalizations.of(context)!
                  //               .check_by_customer_phone_number,
                  //           height: 40,
                  //           width: 230,
                  //           BorderColor: MAIN_COLOR,
                  //           FontSize: 13,
                  //           OnClickFunction: () {
                  //             NavigatorFunction(context,
                  //                 CheckMaintennanceRequestByCustomerPhoneNumber());
                  //           },
                  //           BorderRaduis: 10,
                  //           ButtonColor: MAIN_COLOR,
                  //           NameColor: Colors.white),
                  //     ),
                  //   ],
                  // ),
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10),
                              child: CustomTextField(
                                  backgroundColor: Color(0xffEBEBEB),
                                  borderColor: Color(0xffEBEBEB),
                                  focusNode: null,
                                  borderRadius: 40,
                                  controller: productSerialNumberController,
                                  hintText: AppLocalizations.of(context)!
                                      .product_serial_number,
                                  height: _formKey.currentState != null
                                      ? _formKey.currentState!.validate()
                                          ? 50
                                          : 70
                                      : 50,
                                  validator: validateProductSerialNumber),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15),
                              child: ButtonWidget(
                                  name: AppLocalizations.of(context)!
                                      .continue_operation,
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: MAIN_COLOR,
                                  FontSize: 18,
                                  OnClickFunction: () async {
                                    if (_formKey.currentState!.validate()) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.black,
                                                ))),
                                          );
                                        },
                                      );
                                      var responseWarranyData = await getRequest(
                                          "$URL_MAINTENNANCE_REQUEST_BY_PRODUCT_SERIAL_NUMBER/${productSerialNumberController.text}");
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (responseWarranyData
                                          .containsKey("response")) {
                                        var Response =
                                            responseWarranyData["response"];
                                        bool checkWarrany =
                                            responseWarranyData["response"]
                                                ["warrantyStatus"];

                                        if (checkWarrany) {
                                          setState(() {
                                            resultMessageWarrantStatus =
                                                AppLocalizations.of(context)!
                                                    .effectice;
                                            maintenceNotes =
                                                responseWarranyData["response"]
                                                        ["notes"] ??
                                                    "";
                                            customerName =
                                                responseWarranyData["response"]
                                                        ["customerName"] ??
                                                    "";
                                            customerPhone =
                                                responseWarranyData["response"]
                                                        ["customerPhone"] ??
                                                    "";

                                            maintenceStatus = maintenceStatusTranslate[
                                                        "${locale.toString()}"]![
                                                    "${responseWarranyData["response"]["status"]}"]
                                                .toString();
                                            maintenceDesc = responseWarranyData[
                                                        "response"][
                                                    "malfunctionDdescription"] ??
                                                "";
                                          });
                                        } else {
                                          setState(() {
                                            resultMessageWarrantStatus =
                                                AppLocalizations.of(context)!
                                                    .not_effectice;
                                            maintenceNotes =
                                                responseWarranyData["response"]
                                                        ["notes"] ??
                                                    "";
                                            customerName =
                                                responseWarranyData["response"]
                                                        ["customerName"] ??
                                                    "";
                                            customerPhone =
                                                responseWarranyData["response"]
                                                        ["customerPhone"] ??
                                                    "";
                                            maintenceStatus =
                                                responseWarranyData["response"]
                                                        ["status"] ??
                                                    "";
                                            maintenceDesc = responseWarranyData[
                                                        "response"][
                                                    "malfunctionDdescription"] ??
                                                "";
                                          });
                                        }

                                        final String serialNumberFirstTwoParts =
                                            productSerialNumberController.text
                                                .split("-")
                                                .take(2)
                                                .join("-");

                                        var productData = await getRequest(
                                            "$URL_PRODUCT_BY_FIRST_SERIAL_PART/$serialNumberFirstTwoParts");
                                        if (productData
                                            .containsKey("response")) {
                                          var imageString =
                                              productData["response"]["image"];
                                          List<String> resultList = [];
                                          if (imageString.isNotEmpty) {
                                            // Check if the imageString is in the expected format
                                            if (imageString != null &&
                                                imageString.startsWith("[") &&
                                                imageString.endsWith("]")) {
                                              resultList = (jsonDecode(
                                                      imageString) as List)
                                                  .map((item) => item as String)
                                                  .toList();
                                            } else {
                                              imageString = "";
                                            }
                                          }
                                          productImage = resultList[0];
                                          productName =
                                              productData["response"]["name"];
                                          setState(() {});
                                        } else {
                                          productImage = "";
                                          productName = "";
                                          setState(() {});
                                        }
                                      } else {
                                        setState(() {
                                          resultMessageWarrantStatus =
                                              AppLocalizations.of(context)!
                                                  .not_effectice;
                                          productImage = "";
                                          productName = "";
                                        });
                                      }
                                    }
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: MAIN_COLOR,
                                  NameColor: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .product_name,
                                            style: TextStyle(
                                                fontSize: 16,
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
                                            productName,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 50,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .warranty_inspection,
                                            style: TextStyle(
                                                fontSize: 16,
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
                                            resultMessageWarrantStatus,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: const Color.fromARGB(255, 228, 228, 228),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.maintenance_status} ${maintenceStatus.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.maintenance_notes} ${maintenceNotes.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.malfunction_description} ${maintenceDesc.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.customer_name} ${customerName.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.customer_phone} ${customerPhone.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? validateProductSerialNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_product_serial_number;
    }
    return null; // Return null if the input is valid
  }
}
