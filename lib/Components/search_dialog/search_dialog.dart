import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Pages/product_screen/product_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/main.dart';
import '../../Constants/constants.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';
import '../button_widget/button_widget.dart';

class SearchResultsWidget extends StatefulWidget {
  final List<dynamic> searchResults;

  SearchResultsWidget({required this.searchResults});

  @override
  _SearchResultsWidgetState createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  @override
  String selectedSize = "";
  String ROLEID = "";
  setSharedPref() async {
    searchController.text = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? RoleID = await prefs.getString('role_id');
    setState(() {
      ROLEID = RoleID.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSharedPref();
  }

  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return SingleChildScrollView(
      // Wrap the entire content in a SingleChildScrollView
      child: Column(
        children: <Widget>[
          if (widget.searchResults == null) // Handle loading state
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: SpinKitFadingCircle(
                  color: MAIN_COLOR,
                  size: 40.0,
                ),
              ),
            )
          else if (widget.searchResults.isNotEmpty &&
              searchController.text != "") // Handle data available
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              color: Colors.white,
              child: ListView.builder(
                itemCount: widget.searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  final arabicPattern = RegExp(r'[\u0600-\u06FF\s]+');
                  bool isArabic = arabicPattern.hasMatch(searchController.text);
                  var imageString = widget.searchResults[index]["image"];
                  if (widget.searchResults.isNotEmpty) {
                    // Check if the imageString is in the expected format
                    if (imageString != null &&
                        imageString.startsWith("[") &&
                        imageString.endsWith("]")) {
                      // Remove square brackets and any surrounding double quotes
                      imageString = imageString
                          .substring(1, imageString.length - 1)
                          .replaceAll('"', '');
                    } else {
                      imageString = "";
                    }
                  }
                  List<String> _initSizes = [];
                  for (int i = 0;
                      i < widget.searchResults[index]["sizes"].length;
                      i++) {
                    _initSizes.add(widget.searchResults[index]["sizes"][i]
                            ["title"]
                        .toString());
                  }
                  return InkWell(
                    onTap: () {
                      NavigatorFunction(
                          context,
                          ProductScreen(
                              name: isArabic
                                  ? widget.searchResults[index]["translations"]
                                      [0]["value"]
                                  : widget.searchResults[index]["name"],
                              category_id: widget.searchResults[index]
                                  ["categoryId"],
                              image: imageString,
                              product_id: widget.searchResults[index]["id"]));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    isArabic
                                        ? widget.searchResults[index]
                                            ["translations"][0]["value"]
                                        : widget.searchResults[index]["name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                      widget.searchResults[index]["name"] ?? "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                              Visibility(
                                visible: ROLEID == "3" && _initSizes.length != 0
                                    ? true
                                    : false,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: MAIN_COLOR)),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: MAIN_COLOR,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: const Color.fromARGB(255, 236, 236, 236),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          else // Handle no results
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.search_no_products,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

TextEditingController searchController = TextEditingController();

void showSearchDialog(BuildContext context) async {
  List<dynamic> searchResults = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 44, 44, 44),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: MAIN_COLOR,
                          blurRadius: 5.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      controller: searchController,
                      onChanged: (value) async {
                        searchResults = await searchProductByKey(value);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 196, 195, 195),
                            fontSize: 12,
                          ),
                          hintText: AppLocalizations.of(context)!
                              .search_by_name_or_number),
                    ),
                  ),
                  SearchResultsWidget(searchResults: searchResults),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
