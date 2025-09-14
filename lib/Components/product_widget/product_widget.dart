import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Pages/product_screen/product_screen.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Constants/constants.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../Server/domains/domains.dart';
import '../../main.dart';
import '../button_widget/button_widget.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';

class ProductWidget extends StatefulWidget {
  final name_ar, name_en, image;
  List<String>? SIZES_EN;
  List<String>? SIZES_AR;
  List<int>? SIZESIDs;
  List? colors;
  bool isTablet = false;
  int id = 0, category_id;
  ProductWidget(
      {super.key,
      required this.name_ar,
      required this.name_en,
      this.isTablet = false,
      required this.image,
      required this.SIZES_EN,
      required this.SIZES_AR,
      required this.SIZESIDs,
      required this.colors,
      required this.category_id,
      required this.id});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  String selectedSize = "";
  String ROLEID = "";
  setSharedPref() async {
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
    final favoriteProvider = Provider.of<FavouriteProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            NavigatorFunction(
                context,
                ProductScreen(
                    name: locale.toString() == "ar"
                        ? widget.name_ar
                        : widget.name_en,
                    image: URLIMAGE + widget.image,
                    category_id: widget.category_id,
                    product_id: widget.id));
          },
          child: Container(
            height: widget.isTablet ? 320 : 230,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ], borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: FancyShimmerImage(
                      imageUrl: widget.image.toString().isNotEmpty
                          ? URLIMAGE + widget.image
                          : "",
                      height: widget.isTablet ? 230 : 190,
                      width: widget.isTablet ? 230 : double.infinity,
                      errorWidget: Image.asset(
                        "assets/images/logo_red.png",
                        fit: BoxFit.contain,
                        height: 50,
                        width: 30,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        locale.toString() == "ar"
                            ? widget.name_ar.toString().length > 20
                                ? widget.name_ar.toString().substring(0, 20)
                                : widget.name_ar.toString()
                            : widget.name_en.toString().length > 20
                                ? widget.name_en.toString().substring(0, 20)
                                : widget.name_en.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible:
                  ROLEID == "3" && widget.SIZES_EN!.length != 0 ? true : false,
              child: InkWell(
                onTap: () {
                  showDialogToAddToCart(
                    SIZES_EN: widget.SIZES_EN,
                    SIZES_AR: widget.SIZES_AR,
                    SIZESIDs: widget.SIZESIDs,
                    category_id: widget.category_id,
                    colors: widget.colors,
                    context: context,
                    image: URLIMAGE + widget.image,
                    product_id: widget.id,
                    selectedSize: selectedSize,
                    cartProvider: cartProvider,
                    name_ar: widget.name_ar,
                    name_en: widget.name_en,
                  );
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)),
                      child: Center(
                          child: FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                        size: 14,
                      )),
                    ),
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final favoriteProvider =
                    Provider.of<FavouriteProvider>(context, listen: false);
                bool isFavorite = favoriteProvider.isProductFavorite(widget.id);
                if (isFavorite) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        actions: <Widget>[
                          Container(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "تحذير",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "هل تريد بالتأكيد حذف المنتج من المفضلة ?",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Center(
                                                  child: Text(
                                                    "الغاء",
                                                    style: TextStyle(
                                                        color: MAIN_COLOR,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () async {
                                                final favoriteProvider =
                                                    Provider.of<
                                                            FavouriteProvider>(
                                                        context,
                                                        listen: false);

                                                await favoriteProvider
                                                    .removeFromFavorite(
                                                        widget.id);
                                                Fluttertoast.showToast(
                                                    msg: AppLocalizations.of(
                                                            context)!
                                                        .fav_deleted_successfully,
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 28, 116, 31),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);

                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Center(
                                                  child: Text(
                                                    "حذف",
                                                    style: TextStyle(
                                                        color: MAIN_COLOR,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final newItem = FavoriteItem(
                    categoryID: widget.category_id,
                    productId: widget.id,
                    name: locale.toString() == "ar"
                        ? widget.name_ar
                        : widget.name_en,
                    image: URLIMAGE + widget.image,
                  );
                  await favoriteProvider.addToFavorite(newItem);
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.fav_added_successfully,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(255, 28, 116, 31),
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Consumer<FavouriteProvider>(
                      builder: (context, favoriteProvider, _) {
                        bool isFavorite =
                            favoriteProvider.isProductFavorite(widget.id);
                        return isFavorite
                            ? IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () async {
                                  final favoriteProvider =
                                      Provider.of<FavouriteProvider>(context,
                                          listen: false);

                                  await favoriteProvider
                                      .removeFromFavorite(widget.id);
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .fav_deleted_successfully,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: const Color.fromARGB(
                                          255, 28, 116, 31),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: MAIN_COLOR,
                                  size: 21,
                                ))
                            : SvgPicture.asset(
                                "assets/images/add_to_favorite.svg",
                                color: Colors.black,
                                fit: BoxFit.cover,
                                width: 21,
                                height: 21,
                              );
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
