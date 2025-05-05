import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/register_screen/register_screen.dart';
import 'package:trust_app_updated/Pages/merchant_screen/check_maintennance_request/check_maintennance_request.dart';
import 'package:trust_app_updated/Pages/merchant_screen/check_maintennance_request_by_customer_phone/product_card_phone_number/product_card_phone_number.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';

import '../../../Components/loading_widget/loading_widget.dart';

class CheckMaintennanceRequestByCustomerPhoneNumber extends StatefulWidget {
  const CheckMaintennanceRequestByCustomerPhoneNumber({super.key});

  @override
  State<CheckMaintennanceRequestByCustomerPhoneNumber> createState() =>
      _CheckMaintennanceRequestByCustomerPhoneNumberState();
}

class _CheckMaintennanceRequestByCustomerPhoneNumberState
    extends State<CheckMaintennanceRequestByCustomerPhoneNumber> {
  @override
  TextEditingController customerPhoneNumberController = TextEditingController();
  String resultMessageWarrantStatus = "";
  String maintenceNotes = "";
  String maintenceStatus = "";
  var maintaincesCard = [];
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Container(
                        // height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
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
                                  backgroundColor: Color(0xffEBEBEB),
                                  borderColor: Color(0xffEBEBEB),
                                  focusNode: null,
                                  borderRadius: 40,
                                  controller: customerPhoneNumberController,
                                  hintText: AppLocalizations.of(context)!
                                      .customer_phone,
                                  height: _formKey.currentState != null
                                      ? _formKey.currentState!.validate()
                                          ? 50
                                          : 70
                                      : 50,
                                  validator: validateProductSerialNumber),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15, bottom: 20),
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
                                          "$URL_MAINTENNANCE_REQUEST_BY_CUSTOMER_PHONE_NUMBER/${customerPhoneNumberController.text}");
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      var Response =
                                          responseWarranyData["response"];
                                      setState(() {
                                        maintaincesCard = Response["data"];
                                      });
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
                  ),
                  Container(
                    child: ListView.builder(
                      itemCount: maintaincesCard.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final maintenance = maintaincesCard[index];
                        bool warrantStatus =
                            maintenance["warrantyStatus"] ?? false;
                        String productName =
                            maintenance?["product"]?["name"] ?? "";

                        return ProductCardPhoneNumber(
                          customerName: maintenance["customerName"] ?? "",
                          customerPhone: maintenance["customerPhone"] ?? "",
                          maintenceDesc:
                              maintenance["malfunctionDdescription"] ?? "",
                          maintenceNotes: maintenance["notes"] ?? "-",
                          maintenceStatus: maintenance["status"] ?? "",
                          productName: productName,
                          resultMessageWarrantStatus: warrantStatus
                              ? AppLocalizations.of(context)!.effectice
                              : AppLocalizations.of(context)!.not_effectice,
                        );
                      },
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
      return AppLocalizations.of(context)!.please_enter_a_customer_phone_number;
    }
    return null; // Return null if the input is valid
  }
}
