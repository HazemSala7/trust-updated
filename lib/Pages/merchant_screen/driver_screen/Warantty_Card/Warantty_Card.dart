import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/Components/text_field_widget/text_field_widget.dart';
import '../../../../Components/button_widget/button_widget.dart';
import '../../../../Constants/constants.dart';
import '../../../../Server/functions/functions.dart';
import '../../../../main.dart';
import '../../../point_of_sales/google_map_view/google_map_view.dart';
import '../driver_screen.dart';

class WarrantyCard extends StatefulWidget {
  final bool warrantieStatus;
  final String customerPhone;
  final String merchantLocation;
  final String productName;
  final String initialStatus;
  final Function? reload;
  final String malfunctionDescription;
  final String notes;
  final int id;
  final int index;
  final int cost;
  final String customerName;
  bool showMore = false;
  bool showCost = false;
  final double latitude;
  final double longitude;

  WarrantyCard({
    this.warrantieStatus = true,
    this.showMore = false,
    required this.showCost,
    this.customerPhone = "",
    this.productName = "",
    this.initialStatus = "",
    required this.index,
    required this.cost,
    this.reload,
    this.malfunctionDescription = "",
    this.merchantLocation = "",
    this.notes = "",
    this.id = 0,
    this.customerName = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  @override
  _WarrantyCardState createState() => _WarrantyCardState();
}

class _WarrantyCardState extends State<WarrantyCard> {
  bool _isChecked = false;
  TextEditingController NotesController = TextEditingController();
  TextEditingController CostController = TextEditingController();

  void _showEditStatusDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        String statusValue = widget.initialStatus.toString() == "done"
            ? "delivered"
            : widget.initialStatus.toString() == "pending"
                ? "in_progress"
                : widget.initialStatus.toString();

        NotesController.text = widget.notes;
        CostController.text = widget.cost.toString();
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Color.fromARGB(198, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.edit,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Visibility(
                            visible: widget.showCost,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                ButtonWidget(
                                  name: AppLocalizations.of(context)!.pending,
                                  height: 40,
                                  width: double.infinity,
                                  BorderColor: MAIN_COLOR,
                                  FontSize: 18,
                                  OnClickFunction: () {
                                    setState(() {
                                      statusValue = "pending";
                                    });
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: statusValue == "pending"
                                      ? MAIN_COLOR
                                      : Colors.white,
                                  NameColor: statusValue == "pending"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          ButtonWidget(
                            name: AppLocalizations.of(context)!.in_progress,
                            height: 40,
                            width: double.infinity,
                            BorderColor: MAIN_COLOR,
                            FontSize: 18,
                            OnClickFunction: () {
                              setState(() {
                                statusValue = "in_progress";
                              });
                            },
                            BorderRaduis: 40,
                            ButtonColor: statusValue == "in_progress"
                                ? MAIN_COLOR
                                : Colors.white,
                            NameColor: statusValue == "in_progress"
                                ? Colors.white
                                : Colors.black,
                          ),
                          Visibility(
                            visible: widget.showCost,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                ButtonWidget(
                                  name: AppLocalizations.of(context)!.done,
                                  height: 40,
                                  width: double.infinity,
                                  BorderColor: MAIN_COLOR,
                                  FontSize: 18,
                                  OnClickFunction: () {
                                    setState(() {
                                      statusValue = "done";
                                    });
                                  },
                                  BorderRaduis: 40,
                                  ButtonColor: statusValue == "done"
                                      ? MAIN_COLOR
                                      : Colors.white,
                                  NameColor: statusValue == "done"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          ButtonWidget(
                            name: AppLocalizations.of(context)!.delivered,
                            height: 40,
                            width: double.infinity,
                            BorderColor: MAIN_COLOR,
                            FontSize: 18,
                            OnClickFunction: () {
                              setState(() {
                                statusValue = "delivered";
                              });
                            },
                            BorderRaduis: 40,
                            ButtonColor: statusValue == "delivered"
                                ? MAIN_COLOR
                                : Colors.white,
                            NameColor: statusValue == "delivered"
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(height: 20),
                          Visibility(
                              visible: widget.showCost,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.cost,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 5),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xffEBEBEB),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: TextField(
                                        controller: CostController,
                                        obscureText: false,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(
                                              bottom: 10, top: 12),
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 85, 84, 84),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .cost,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.notes,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 5,
                                        bottom: 20),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Color(0xffEBEBEB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: NotesController,
                                        obscureText: false,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(
                                              bottom: 10, top: 12),
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 85, 84, 84),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .notes,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          ButtonWidget(
                            name: AppLocalizations.of(context)!.save_date,
                            height: 30,
                            width: 90,
                            BorderColor: MAIN_COLOR,
                            FontSize: 12,
                            OnClickFunction: () async {
                              if (widget.showMore) {
                                var finalObject = {
                                  "id": widget.id,
                                  "notes": "${NotesController.text}",
                                  "maintenanceCost": CostController.text
                                };
                                await editMaintanenceRequestStatusArray(
                                    finalObject, context);
                                Navigator.pop(context);
                                if (widget.reload != null) {
                                  widget.reload!();
                                }
                              } else {
                                await editMaintanenceRequestStatus(
                                    widget.id, statusValue, context);
                                Navigator.pop(context);
                                if (widget.reload != null) {
                                  widget.reload!();
                                }
                              }
                            },
                            BorderRaduis: 20,
                            ButtonColor: MAIN_COLOR,
                            NameColor: Colors.white,
                          ),
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
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: locale.toString() == "ar"
          ? Alignment.bottomLeft
          : Alignment.bottomRight,
      children: [
        Stack(
          alignment: locale.toString() == "ar"
              ? Alignment.topLeft
              : Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
              child: Container(
                width: double.infinity,
                height: widget.showMore ? null : 177,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 211, 211, 211)
                            .withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: const Color.fromARGB(255, 238, 238, 238),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MAIN_COLOR)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .merchant_name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.customerName.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .product_name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.productName.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .order_status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        locale.toString() == "ar"
                                            ? widget.initialStatus == "pending"
                                                ? "بانتظار التوصيل للصيانة"
                                                : widget.initialStatus ==
                                                        "in_progress"
                                                    ? "في الصيانة"
                                                    : widget.initialStatus ==
                                                            "done"
                                                        ? "تم الصيانة"
                                                        : "تم التسليم للتاجر"
                                            : widget.initialStatus,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .merchant_phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.customerPhone,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.merchant_address} : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.merchantLocation,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: widget.showMore,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.cost,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            widget.cost.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .malfunction_description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              widget.malfunctionDescription
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .notes_warranty,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              widget.notes,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<int>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 1,
                            child: ListTile(
                              leading: Icon(
                                Icons.edit,
                                color: MAIN_COLOR,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.edit,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child: ListTile(
                              leading: Icon(
                                Icons.location_city,
                                color: MAIN_COLOR,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.my_location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                    onSelected: (int value) {
                      _handleMenuSelection(value);
                    },
                    child: Icon(Icons.more_vert)),
              ),
            ),
          ],
        ),
        Padding(
          padding: locale.toString() == "ar"
              ? EdgeInsets.only(left: 15, bottom: 5)
              : EdgeInsets.only(right: 15, bottom: 5),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Checkbox(
              shape: CircleBorder(), // Makes the checkbox itself circular
              activeColor: MAIN_COLOR,
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
                warrantiesCard[widget.index]["status"] = _isChecked;
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleMenuSelection(int value) {
    // Handle the selected option
    switch (value) {
      case 1:
        _showEditStatusDialog();

        break;
      case 2:
        NavigatorFunction(
          context,
          GoogleMapView(
            latt: widget.latitude,
            long: widget.longitude,
          ),
        );
        break;
      case 3:
        // Handle option 3
        break;
      default:
        break;
    }
  }
}
