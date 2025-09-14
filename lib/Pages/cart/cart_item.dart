import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Components/delete_dialog/delete_dialog.dart';
import 'package:trust_app_updated/Pages/product_screen/product_screen.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/main.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import '../../Components/button_widget/button_widget.dart';
import '../../Constants/constants.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Server/functions/functions.dart';

class CartItemCard extends StatefulWidget {
  Function removeProduct;
  CartProvider? cartProvider;

  CartItem item;
  CartItemCard({
    Key? key,
    required this.item,
    required this.removeProduct,
    required this.cartProvider,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  int? selectedIndex;
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorFunction(
            context,
            ProductScreen(
                name: widget.item.name_ar,
                category_id: widget.item.categoryID,
                image: widget.item.image,
                product_id: widget.item.productId));
      },
      child: Container(
        width: double.infinity,
        height: 110,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        widget.item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/logo_well.png",
                            fit: BoxFit.cover,
                            height: 50,
                            width: 70,
                          );
                        },
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(locale.toString() == "ar"
                              ? widget.item.name_ar
                              : widget.item.name_en),
                          Text(locale.toString() == "ar"
                              ? widget
                                  .item.sizes_ar[widget.item.selectedSizeIndex]
                              : widget.item
                                  .sizes_en[widget.item.selectedSizeIndex]),
                          Visibility(
                            visible: widget.item.color_en == "" ? false : true,
                            child: Column(
                              children: [
                                Text(locale.toString() == "ar"
                                    ? widget.item.color_ar
                                    : widget.item.color_en),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  int quantity = int.parse(
                                      widget.item.quantity.toString());
                                  // Call the updateCartItem function in CartProvider
                                  widget.cartProvider?.updateCartItem(
                                    widget.item.copyWith(
                                      quantity: quantity + 1,
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: locale.toString() ==
                                                  "ar"
                                              ? BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))
                                              : BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                          color: MAIN_COLOR),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MAIN_COLOR, width: 1)),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '${widget.item.quantity}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        // color: Color(0xffB23634),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (widget.item.quantity > 1) {
                                    int quantity = int.parse(
                                        widget.item.quantity.toString());
                                    // Call the updateCartItem function in CartProvider
                                    widget.cartProvider?.updateCartItem(
                                      widget.item.copyWith(
                                        quantity: quantity - 1,
                                      ),
                                    );
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: locale.toString() == "ar"
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10))
                                            : BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                        color: MAIN_COLOR),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.minus,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          String selectedColorName = locale.toString() == "ar"
                              ? widget.item.color_ar
                              : widget.item.color_en;
                          int selectedIndex = 0;
                          String selectedSize = locale.toString() == "ar"
                              ? widget.item.size_ar
                              : widget.item.size_en;
                          String selectedImage = widget.item.image;
                          TextEditingController _countController =
                              TextEditingController();
                          _countController.text =
                              widget.item.quantity.toString();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              bool isTablet =
                                  MediaQuery.of(context).size.shortestSide >
                                      600;
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                bool emptySizes = false;
                                bool emptyColors = false;

                                List<int> _Counters = [];
                                List<String> _NamesEN = [];
                                List<String> _NamesAR = [];
                                List<String> _Images = [];
                                for (int i = 0;
                                    i < widget.item.colorsNamesEN.length;
                                    i++) {
                                  _Counters.add(0);
                                  _NamesEN.add(widget.item.colorsNamesEN[i]);
                                  _NamesAR.add(widget.item.colorsNamesAR[i]);
                                  _Images.add(widget.item.colorsImages[i]);
                                }
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  actionsPadding: EdgeInsets.zero,
                                  titlePadding: EdgeInsets.zero,
                                  title: Container(
                                      height: 50,
                                      width: double.infinity,
                                      color: MAIN_COLOR,
                                      child: Center(
                                          child: Text(
                                        AppLocalizations.of(context)!.edit,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ))),
                                  content: SingleChildScrollView(
                                    child: Container(
                                      width: isTablet
                                          ? MediaQuery.of(context).size.width
                                          : 300,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 15, right: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .size,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Visibility(
                                                  visible: emptySizes,
                                                  child: Text(
                                                    "(${AppLocalizations.of(context)!.select_size})",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          locale.toString() == "ar"
                                              ? Column(
                                                  children: widget.item.sizes_ar
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    final index = entry.key;
                                                    final size = entry.value;

                                                    return RadioListTile(
                                                      activeColor: MAIN_COLOR,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Text(size),
                                                      value: size,
                                                      groupValue: selectedSize,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSize =
                                                              value as String;
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                )
                                              : Column(
                                                  children: widget.item.sizes_en
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    final index = entry.key;
                                                    final size = entry.value;

                                                    return RadioListTile(
                                                      activeColor: MAIN_COLOR,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Text(size),
                                                      value: size,
                                                      groupValue: selectedSize,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSize =
                                                              value as String;
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Color.fromARGB(
                                                255, 167, 167, 167),
                                          ),
                                          Visibility(
                                            visible: selectedColorName == ""
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 15, right: 15),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .color,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Visibility(
                                                    visible: emptyColors,
                                                    child: Text(
                                                      "(${AppLocalizations.of(context)!.select_color})",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: selectedColorName == ""
                                                ? false
                                                : true,
                                            child: Container(
                                              width: 300,
                                              height: 380,
                                              child: ListView.builder(
                                                  key: UniqueKey(),
                                                  itemCount: widget.item
                                                      .colorsNamesEN.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15,
                                                              left: 15,
                                                              top: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            child:
                                                                RadioListTile(
                                                              activeColor:
                                                                  MAIN_COLOR,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: Text(locale
                                                                          .toString() ==
                                                                      "ar"
                                                                  ? _NamesAR[
                                                                      index]
                                                                  : _NamesEN[
                                                                      index]),
                                                              value: locale
                                                                          .toString() ==
                                                                      "ar"
                                                                  ? _NamesAR[
                                                                      index]
                                                                  : _NamesEN[
                                                                      index],
                                                              groupValue:
                                                                  selectedColorName,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedColorName =
                                                                      value!;
                                                                  selectedImage =
                                                                      _Images[
                                                                          index];
                                                                  selectedIndex =
                                                                      index;
                                                                });
                                                              },
                                                              selected: locale
                                                                          .toString() ==
                                                                      "ar"
                                                                  ? _NamesEN[
                                                                          index] ==
                                                                      selectedColorName
                                                                  : _NamesAR[
                                                                          index] ==
                                                                      selectedColorName,
                                                            ),
                                                          ),
                                                          Image.network(
                                                            URLIMAGE +
                                                                _Images[index],
                                                            height: 30,
                                                            width: 30,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 25, right: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      var COUNT = int.parse(
                                                          _countController
                                                              .text);
                                                      COUNT++;
                                                      _countController.text =
                                                          COUNT.toString();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius: locale
                                                                        .toString() ==
                                                                    "ar"
                                                                ? BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))
                                                                : BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10)),
                                                            color: MAIN_COLOR),
                                                        child: Center(
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: MAIN_COLOR,
                                                            width: 1)),
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 5),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          controller:
                                                              _countController,
                                                        ),
                                                      ),
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    var COUNT = int.parse(
                                                        _countController.text);

                                                    if (COUNT > 1) {
                                                      setState(() {
                                                        if (COUNT != 1) COUNT--;

                                                        _countController.text =
                                                            COUNT.toString();
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: locale
                                                                      .toString() ==
                                                                  "en"
                                                              ? BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          10))
                                                              : BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          10)),
                                                          color: MAIN_COLOR),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ButtonWidget(
                                        name:
                                            AppLocalizations.of(context)!.edit,
                                        height: 50,
                                        width: double.infinity,
                                        BorderColor: MAIN_COLOR,
                                        FontSize: 16,
                                        OnClickFunction: () {
                                          if (selectedColorName == "") {
                                            widget.cartProvider?.updateCartItem(
                                              widget.item.copyWith(
                                                selectedSizeIndex:
                                                    selectedIndex,
                                                size_en: selectedSize,
                                                color_en:
                                                    _NamesEN[selectedIndex],
                                                color_ar:
                                                    _NamesAR[selectedIndex],
                                                quantity: int.parse(
                                                    _countController.text),
                                              ),
                                            );
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(
                                                        context)!
                                                    .edit_success,
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 28, 116, 31),
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.pop(context);
                                          } else {
                                            widget.cartProvider?.updateCartItem(
                                              widget.item.copyWith(
                                                selectedSizeIndex:
                                                    selectedIndex,
                                                size_en: selectedSize,
                                                // size_id: widget.,
                                                quantity: int.parse(
                                                    _countController.text),
                                                image: URLIMAGE + selectedImage,
                                                color_en:
                                                    _NamesEN[selectedIndex],
                                                color_ar:
                                                    _NamesAR[selectedIndex],
                                              ),
                                            );
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(
                                                        context)!
                                                    .edit_success,
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 28, 116, 31),
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                        BorderRaduis: 0,
                                        ButtonColor: MAIN_COLOR,
                                        NameColor: Colors.white)
                                  ],
                                );
                              });
                            },
                          );
                        },
                        child: FaIcon(
                          FontAwesomeIcons.pencil,
                          color: MAIN_COLOR,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              TextEditingController SuggestionController =
                                  TextEditingController();
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
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                "استفسار ...",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                  height: 100,
                                                  width: 220,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 9, 9, 9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    controller:
                                                        SuggestionController,
                                                    obscureText: false,
                                                    maxLines: 50,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ButtonWidget(
                                                  name: "أرسل",
                                                  height: 30,
                                                  width: 90,
                                                  BorderColor: MAIN_COLOR,
                                                  FontSize: 12,
                                                  OnClickFunction: () async {
                                                    widget.cartProvider
                                                        ?.updateCartItem(
                                                      widget.item.copyWith(
                                                          notes:
                                                              SuggestionController
                                                                  .text),
                                                    );
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg: AppLocalizations
                                                                .of(context)!
                                                            .edit_success,
                                                        toastLength: Toast
                                                            .LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 2,
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                28, 116, 31),
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  },
                                                  BorderRaduis: 20,
                                                  ButtonColor: MAIN_COLOR,
                                                  NameColor: Colors.white)
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
                                          )),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: FaIcon(
                          FontAwesomeIcons.message,
                          color: MAIN_COLOR,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteDialog(DeleteFunction: () {
                                  widget.removeProduct();
                                });
                              });
                        },
                        child: FaIcon(
                          FontAwesomeIcons.deleteLeft,
                          color: MAIN_COLOR,
                          size: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color.fromARGB(255, 200, 200, 200),
            )
          ],
        ),
      ),
    );
  }
}
