import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/register_screen/register_screen.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../../Components/loading_widget/loading_widget.dart';

class AddWarranty extends StatefulWidget {
  const AddWarranty({super.key});

  @override
  State<AddWarranty> createState() => _AddWarrantyState();
}

class _AddWarrantyState extends State<AddWarranty> {
  @override
  TextEditingController productSerialNumberController = TextEditingController();
  TextEditingController CustomerNameController = TextEditingController();
  TextEditingController CustomerPhoneController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController IDNumberController = TextEditingController();
  String resultMessageWarrantStatus = "";
  String productImage = "";
  String productName = "";
  int productID = 0;
  int merchantID = 0;
  bool showCustomerDetails = false;
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
                AppLocalizations.of(context)!.amending_the_warranty,
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
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 10),
                                child: CustomTextField(
                                    backgroundColor: Color(0xffEBEBEB),
                                    borderColor: Color(0xffEBEBEB),
                                    focusNode: null,
                                    borderRadius: 40,
                                    onChanged: (_) {
                                      selectedProductNumber = false;
                                      CustomerNameController.text = "";
                                      CustomerPhoneController.text = "";
                                      NotesController.text = "";

                                      setState(() {});
                                    },
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
                                      selectedProductNumber = true;
                                      var responseWarranyData = await getRequest(
                                          "$URL_WARRANTIES_BY_PRODUCT_SERIAL_NUMBER/${productSerialNumberController.text}");
                                      final String serialNumberFirstTwoParts =
                                          productSerialNumberController.text
                                              .split("-")
                                              .take(2)
                                              .join("-");

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
                                        productID =
                                            productData["response"]["id"] ?? 0;

                                        setState(() {});
                                      } else {
                                        productImage = "";
                                        productName = "";
                                        setState(() {});
                                      }
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (responseWarranyData
                                          .containsKey("response")) {
                                        setState(() {
                                          resultMessageWarrantStatus =
                                              AppLocalizations.of(context)!
                                                  .effectice;
                                          showCustomerDetails = true;

                                          merchantID =
                                              responseWarranyData["response"]
                                                      ["merchantId"] ??
                                                  1;
                                          CustomerNameController.text =
                                              responseWarranyData["response"]
                                                  ["customerName"];
                                          CustomerPhoneController.text =
                                              responseWarranyData["response"]
                                                  ["customerPhone"];
                                        });
                                      } else {
                                        setState(() {
                                          resultMessageWarrantStatus =
                                              AppLocalizations.of(context)!
                                                  .not_effectice;
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        child: Text(
                                          productName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                            Visibility(
                              visible: resultMessageWarrantStatus.toString() ==
                                          AppLocalizations.of(context)!
                                              .effectice ||
                                      resultMessageWarrantStatus.toString() ==
                                          "" ||
                                      productName.toString() == "" ||
                                      selectedProductNumber == false
                                  ? false
                                  : true,
                              child: Form(
                                key: _formKey2,
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
                                          controller: CustomerNameController,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .customer_name,
                                          height: _formKey.currentState != null
                                              ? _formKey.currentState!
                                                      .validate()
                                                  ? 50
                                                  : 70
                                              : 50,
                                          validator: validateCustomerName),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 15, top: 10),
                                      child: CustomTextField(
                                          backgroundColor: Color(0xffEBEBEB),
                                          borderColor: Color(0xffEBEBEB),
                                          focusNode: null,
                                          borderRadius: 40,
                                          controller: CustomerPhoneController,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .customer_phone,
                                          height: _formKey.currentState != null
                                              ? _formKey.currentState!
                                                      .validate()
                                                  ? 50
                                                  : 70
                                              : 50,
                                          validator: validateCustomerMobile),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 15, top: 10),
                                      child: CustomTextField(
                                          backgroundColor: Color(0xffEBEBEB),
                                          borderColor: Color(0xffEBEBEB),
                                          focusNode: null,
                                          borderRadius: 40,
                                          controller: NotesController,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .notes,
                                          height: 50,
                                          validator: null),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 15, top: 10),
                                      child: CustomTextField(
                                          backgroundColor: Color(0xffEBEBEB),
                                          borderColor: Color(0xffEBEBEB),
                                          focusNode: null,
                                          borderRadius: 40,
                                          controller: IDNumberController,
                                          hintText: "رقم الهوية",
                                          height: 50,
                                          validator: null),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 15, top: 15),
                                      child: ButtonWidget(
                                          name: "تأكيد المعلومات",
                                          height: 50,
                                          width: double.infinity,
                                          BorderColor: MAIN_COLOR,
                                          FontSize: 18,
                                          OnClickFunction: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                              await addWarranty(
                                                  CustomerPhoneController.text,
                                                  CustomerNameController.text,
                                                  productSerialNumberController
                                                      .text,
                                                  productID.toString(),
                                                  IDNumberController.text,
                                                  merchantID.toString(),
                                                  "",
                                                  context);
                                              Navigator.pop(context);
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

  bool selectedProductNumber = false;
  bool _hasError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String? validateProductSerialNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_product_serial_number;
    }
    return null; // Return null if the input is valid
  }

  String? validateCustomerName(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_a_your_customer_name;
    }
    return null; // Return null if the input is valid
  }

  String? validateCustomerMobile(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_a_customer_phone_number;
    }
    return null; // Return null if the input is valid
  }
}
