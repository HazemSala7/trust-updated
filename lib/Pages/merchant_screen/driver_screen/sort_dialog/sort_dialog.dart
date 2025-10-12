import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
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

  SortDialog({
    Key? key,
    this.initialFromDate,
    this.initialEndDate,
    this.initialCountryID,
    this.initialSelectedStatus,
    this.initialSelectedCategory,
    required this.onSortSelected,
    required this.AllCountries,
    required this.PendingStatus,
    required this.initialSelectedSortCriteria,
    required this.DoneStatus,
  }) : super(key: key);

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
    selectedStatus = widget.initialSelectedStatus ?? "pending";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.order_by_countries,
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: widget.AllCountries.any((country) =>
                            country['countryId'] == selectedCity) ||
                        selectedCity == -1
                    ? selectedCity
                    : null,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 24,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: -1,
                    child: Text(locale == "ar" ? "الجميع" : "All"),
                  ),
                  ...widget.AllCountries.map<DropdownMenuItem<int>>((country) {
                    int countryId = country['countryId'] ?? 0;
                    String countryName = country['countryName'] ?? "";
                    int count = country['count'] ?? 0;

                    return DropdownMenuItem<int>(
                      value: countryId,
                      child: Text("$countryName , $count"),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.sort_by_order_status,
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: selectedStatus,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 24,
                items: [
                  DropdownMenuItem(
                    value: "pending",
                    child: Text(
                        "${AppLocalizations.of(context)!.pending} (${widget.PendingStatus})"),
                  ),
                  DropdownMenuItem(
                    value: "done",
                    child: Text(
                        "${AppLocalizations.of(context)!.done} (${widget.DoneStatus})"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.order_by,
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: selectedSortCriteria.isNotEmpty
                    ? selectedSortCriteria
                    : null,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 24,
                items: [
                  DropdownMenuItem(
                    value: "new",
                    child: Text(
                        AppLocalizations.of(context)!.new_maintenance_requests),
                  ),
                  DropdownMenuItem(
                    value: "late",
                    child: Text(AppLocalizations.of(context)!.order_late),
                  ),
                  DropdownMenuItem(
                    value: "very_late",
                    child: Text(AppLocalizations.of(context)!.order_too_late),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSortCriteria = value!;
                    _updateDateRange(value);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  name: AppLocalizations.of(context)!.reset,
                  height: 50,
                  width: double.infinity,
                  BorderColor: const Color(0xffE8E2DB),
                  FontSize: 18,
                  OnClickFunction: _resetFilters,
                  BorderRaduis: 40,
                  ButtonColor: const Color(0xffE8E2DB),
                  NameColor: MAIN_COLOR,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ButtonWidget(
                  name: AppLocalizations.of(context)!.apply,
                  height: 50,
                  width: double.infinity,
                  BorderColor: MAIN_COLOR,
                  FontSize: 18,
                  OnClickFunction: _applyFilters,
                  BorderRaduis: 40,
                  ButtonColor: MAIN_COLOR,
                  NameColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateDateRange(String sortCriteria) {
    DateTime now = DateTime.now();
    switch (sortCriteria) {
      case "new":
        fromDate =
            now.subtract(const Duration(days: 3)).toString().split(' ')[0];
        endDate = now.toString().split(' ')[0];
        break;
      case "late":
        fromDate =
            now.subtract(const Duration(days: 7)).toString().split(' ')[0];
        endDate =
            now.subtract(const Duration(days: 3)).toString().split(' ')[0];
        break;
      case "very_late":
        fromDate = DateTime(now.year, 1, 1).toString().split(' ')[0];
        endDate = now.toString().split(' ')[0];
        break;
    }
  }

  void _resetFilters() {
    setState(() {
      selectedCity = -1;
      selectedSortCriteria = "";
      selectedStatus = "pending";
      fromDate = "";
      endDate = "";
    });
  }

  void _applyFilters() {
    widget.onSortSelected(
      fromDate,
      endDate,
      selectedCity.toString(),
      selectedStatus,
      selectedCategory,
      selectedSortCriteria,
    );
    Navigator.pop(context);
  }
}
