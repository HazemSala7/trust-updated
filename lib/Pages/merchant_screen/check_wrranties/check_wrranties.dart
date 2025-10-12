import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/register_screen/register_screen.dart';
import 'package:trust_app_updated/Pages/merchant_screen/add_maintanence_request/add_maintanence_request.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';

import '../../../Components/loading_widget/loading_widget.dart';

class CheckWrranties extends StatefulWidget {
  const CheckWrranties({super.key});

  @override
  State<CheckWrranties> createState() => _CheckWrrantiesState();
}

class _CheckWrrantiesState extends State<CheckWrranties> {
  @override
  TextEditingController productSerialNumberController = TextEditingController();
  String resultMessageWarrantStatus = "";
  String productImage = "";
  String productName = "";
  String WarrantCreatedAt = "";
  String customerName = "";
  bool showButton = false;
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
                AppLocalizations.of(context)!.warranty_inspection,
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
              padding: const EdgeInsets.only(
                  right: 25, left: 25, top: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo_red.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 10),
                            child: CustomTextField(
                                backgroundColor: Color(0xffF7F9FA),
                                borderColor: Color(0xffEBEBEB),
                                focusNode: null,
                                borderRadius: 20,
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
                                right: 15, left: 15, top: 15, bottom: 30),
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
                                        "$URL_WARRANTIES_BY_PRODUCT_SERIAL_NUMBER/${productSerialNumberController.text}");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (responseWarranyData
                                        .containsKey("response")) {
                                      setState(() {
                                        showButton = true;
                                        resultMessageWarrantStatus =
                                            AppLocalizations.of(context)!
                                                .effectice;
                                      });
                                      final String serialNumberFirstTwoParts =
                                          productSerialNumberController.text
                                              .split("-")
                                              .take(2)
                                              .join("-");
                                      WarrantCreatedAt =
                                          responseWarranyData["response"]
                                                  ["createdAt"]
                                              .toString()
                                              .substring(0, 10);
                                      customerName =
                                          responseWarranyData["response"]
                                                  ["customerName"] ??
                                              "-";

                                      var productData = await getRequest(
                                          "$URL_PRODUCT_BY_FIRST_SERIAL_PART/$serialNumberFirstTwoParts");
                                      if (productData.containsKey("response")) {
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
                                        showButton = false;
                                        productImage = "";
                                        customerName = "";
                                        productName = "";
                                      });
                                    }
                                  }
                                },
                                BorderRaduis: 40,
                                ButtonColor: MAIN_COLOR,
                                NameColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: productName.toString().isNotEmpty,
                    child: Container(
                      height: 390,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 15),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffF7F9FA)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/product-icon.svg",
                                          color: MAIN_COLOR,
                                          fit: BoxFit.cover,
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.product_name}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          productName,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: productName.toString().isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: resultMessageWarrantStatus ==
                                            AppLocalizations.of(context)!
                                                .effectice
                                        ? Color(0xffEEF7ED)
                                        : Color(0xffF7EDED)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: resultMessageWarrantStatus ==
                                                    AppLocalizations.of(
                                                            context)!
                                                        .effectice
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        resultMessageWarrantStatus,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 15),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffF7F9FA)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/person-icon.svg",
                                          color: MAIN_COLOR,
                                          fit: BoxFit.cover,
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.customer_name}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          customerName,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 15),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffF7F9FA)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/date-icon.svg",
                                              color: MAIN_COLOR,
                                              fit: BoxFit.cover,
                                              width: 20,
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              locale.toString() == "ar"
                                                  ? "تاريخ الشراء"
                                                  : "Purchase date",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: locale.toString() == "ar"
                                              ? const EdgeInsets.only(left: 30)
                                              : const EdgeInsets.only(
                                                  right: 30),
                                          child: Text(
                                            WarrantCreatedAt,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: showButton,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 40, right: 15, left: 15, bottom: 10),
                              child: ButtonWidget(
                                  name: "ارسال الى الصيانة",
                                  height: 50,
                                  width: double.infinity,
                                  BorderColor: MAIN_COLOR,
                                  FontSize: 16,
                                  OnClickFunction: () {
                                    NavigatorFunction(
                                        context,
                                        AddMaintanenceRequest(
                                          prodSerialNumber:
                                              productSerialNumberController
                                                  .text,
                                        ));
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: MAIN_COLOR,
                                  NameColor: Colors.white),
                            ),
                          )
                        ],
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
