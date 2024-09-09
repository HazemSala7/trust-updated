import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/main.dart';

import '../../../../Components/button_widget/button_widget.dart';

class SortDialog extends StatefulWidget {
  final Function(String, String, String, String, String, String) onSortSelected;
  var AllCountries, PendingStatus, DoneStatus;
  final String? initialFromDate;
  final String? initialEndDate;
  final String? initialCountryID;
  final String? initialSelectedStatus;
  final String? initialSelectedCategory;
  final String initialSelectedSortCriteria;
  SortDialog(
      {Key? key,
      this.initialFromDate,
      this.initialEndDate,
      this.initialCountryID,
      this.initialSelectedStatus,
      this.initialSelectedCategory,
      required this.onSortSelected,
      required this.AllCountries,
      required this.PendingStatus,
      required this.initialSelectedSortCriteria,
      required this.DoneStatus})
      : super(key: key);

  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  int? selectedCity;
  String selectedSortCriteria = "";
  String selectedCategory = "all";
  String selectedStatus = "pending";

  String fromDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();
    selectedCity = int.tryParse(widget.initialCountryID ?? "0");
    selectedSortCriteria = widget.initialSelectedSortCriteria;
    selectedCategory = widget.initialSelectedCategory ?? "all";
    fromDate = widget.initialFromDate ?? "";
    endDate = widget.initialEndDate ?? "";
    selectedStatus = widget.initialSelectedStatus ?? "";
    if (selectedSortCriteria != "") {
      buttonSelection[selectedSortCriteria!] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusArray = [
      {
        "name": AppLocalizations.of(context)!.pending,
        "count": widget.PendingStatus
      },
      {"name": AppLocalizations.of(context)!.done, "count": widget.DoneStatus}
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
        //   child: Row(
        //     children: [
        //       Text(AppLocalizations.of(context)!.order_by_countries,
        //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: ButtonWidget(
        //           name: AppLocalizations.of(context)!.all,
        //           height: 40,
        //           width: double.infinity,
        //           BorderColor: MAIN_COLOR,
        //           FontSize: 18,
        //           OnClickFunction: () {
        //             selectedCategory = "all";
        //             // AllProducts = [];
        //             // _page = 1;
        //             // _firstLoad();
        //             setState(() {});
        //           },
        //           BorderRaduis: 40,
        //           ButtonColor:
        //               selectedCategory == "all" ? MAIN_COLOR : Colors.white,
        //           NameColor:
        //               selectedCategory == "all" ? Colors.white : Colors.black,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 15,
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: ButtonWidget(
        //           name: AppLocalizations.of(context)!.hebron,
        //           height: 40,
        //           width: double.infinity,
        //           BorderColor: MAIN_COLOR,
        //           FontSize: 18,
        //           OnClickFunction: () {
        //             selectedCategory = "hebron";
        //             // _page = 1;
        //             // AllProducts = [];
        //             // _firstLoad();
        //             setState(() {});
        //           },
        //           BorderRaduis: 40,
        //           ButtonColor:
        //               selectedCategory == "hebron" ? MAIN_COLOR : Colors.white,
        //           NameColor: selectedCategory == "hebron"
        //               ? Colors.white
        //               : Colors.black,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 15,
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: ButtonWidget(
        //           name: AppLocalizations.of(context)!.ramallah,
        //           height: 40,
        //           width: double.infinity,
        //           BorderColor: MAIN_COLOR,
        //           FontSize: 18,
        //           OnClickFunction: () {
        //             selectedCategory = "ramallah";
        //             // _page = 1;
        //             // AllProducts = [];
        //             // _firstLoad();
        //             setState(() {});
        //           },
        //           BorderRaduis: 40,
        //           ButtonColor: selectedCategory == "ramallah"
        //               ? MAIN_COLOR
        //               : Colors.white,
        //           NameColor: selectedCategory == "ramallah"
        //               ? Colors.white
        //               : Colors.black,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.order_by_countries,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Wrap(
                spacing: 5.0,
                runSpacing: 4.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCity = -1; // or any value you prefer for "All"
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: MAIN_COLOR),
                        color: selectedCity == -1 ? MAIN_COLOR : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          locale.toString() == "ar" ? "الجميع" : "All",
                          style: TextStyle(
                            color:
                                selectedCity == -1 ? Colors.white : MAIN_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(widget.AllCountries.length, (index) {
                    String city =
                        widget.AllCountries[index]["countryName"] ?? "";
                    int cityCount = widget.AllCountries[index]["count"] ?? 0;
                    int countryId =
                        widget.AllCountries[index]["countryId"] ?? 0;
                    bool isSelected = selectedCity == countryId;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCity = countryId;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: MAIN_COLOR),
                          color: isSelected ? MAIN_COLOR : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "$city , $cityCount",
                            style: TextStyle(
                              color: isSelected ? Colors.white : MAIN_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
          child: Row(
            children: [
              Text(AppLocalizations.of(context)!.sort_by_order_status,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Wrap(
            spacing: 5.0,
            runSpacing: 4.0,
            children: List.generate(statusArray.length, (index) {
              String _selectedStatus = index == 0 ? "pending" : "done";
              bool isSelected = selectedStatus == _selectedStatus;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    setState(() {
                      selectedStatus = "pending";
                    });
                  } else {
                    setState(() {
                      selectedStatus = "done";
                    });
                  }
                },
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: MAIN_COLOR),
                    color: isSelected ? MAIN_COLOR : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "${statusArray[index]["name"]} , ${statusArray[index]["count"]}",
                      style: TextStyle(
                          color: isSelected ? Colors.white : MAIN_COLOR,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(AppLocalizations.of(context)!.order_by,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buildActionButton(
                          AppLocalizations.of(context)!
                              .new_maintenance_requests,
                          "new")),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: _buildActionButton(
                          AppLocalizations.of(context)!.order_late, 'late')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buildActionButton(
                          AppLocalizations.of(context)!.order_too_late,
                          'very_late')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 30),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ButtonWidget(
                    name: AppLocalizations.of(context)!.reset,
                    height: 50,
                    width: double.infinity,
                    BorderColor: Color(0xffE8E2DB),
                    FontSize: 18,
                    OnClickFunction: () {
                      setState(() {
                        selectedCity = -1;
                        selectedSortCriteria = "very_late";
                        bool isSelected =
                            buttonSelection[selectedSortCriteria] ?? false;
                        buttonSelection.updateAll((key, value) => false);
                        DateTime now = DateTime.now();
                        buttonSelection["very_late"] = !isSelected;
                        fromDate =
                            DateTime(now.year, 1, 1).toString().split(' ')[0];
                        endDate = now.toString().split(' ')[0];
                      });
                    },
                    BorderRaduis: 40,
                    ButtonColor: Color(0xffE8E2DB),
                    NameColor: MAIN_COLOR),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: ButtonWidget(
                    name: AppLocalizations.of(context)!.apply,
                    height: 50,
                    width: double.infinity,
                    BorderColor: MAIN_COLOR,
                    FontSize: 18,
                    OnClickFunction: () {
                      widget.onSortSelected(
                          fromDate,
                          endDate,
                          widget.AllCountries.length == 0
                              ? "null"
                              : selectedCity.toString(),
                          selectedStatus.toString() == "pending"
                              ? "pending"
                              : "done",
                          selectedCategory.toString(),
                          selectedSortCriteria);
                      Navigator.pop(context);
                    },
                    BorderRaduis: 40,
                    ButtonColor: MAIN_COLOR,
                    NameColor: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, bool> buttonSelection = {
    'new': false,
    'late': false,
    'very_late': false,
  };

  Widget _buildActionButton(String text, String sortCriteria) {
    bool isSelected = buttonSelection[sortCriteria] ?? false;
    return MaterialButton(
      onPressed: () {
        setState(() {
          buttonSelection.updateAll((key, value) => false);
          buttonSelection[sortCriteria] = !isSelected;
          if (isSelected) {
            selectedSortCriteria = "";
            fromDate = "";
            endDate = "";
          } else {
            selectedSortCriteria = sortCriteria;
            DateTime now = DateTime.now();
            switch (sortCriteria) {
              case "new":
                fromDate =
                    now.subtract(Duration(days: 3)).toString().split(' ')[0];
                endDate = now.toString().split(' ')[0];
                selectedSortCriteria = "new";
                break;
              case "late":
                fromDate =
                    now.subtract(Duration(days: 7)).toString().split(' ')[0];
                endDate =
                    now.subtract(Duration(days: 3)).toString().split(' ')[0];
                selectedSortCriteria = "late";
                break;
              case "very_late":
                fromDate = DateTime(now.year, 1, 1).toString().split(' ')[0];
                endDate = now.toString().split(' ')[0];
                selectedSortCriteria = "very_late";
                break;
            }
          }
        });
      },
      color: isSelected ? MAIN_COLOR : Color.fromARGB(101, 236, 234, 234),
      elevation: 0,
      height: 50,
      minWidth: 200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
