import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/product_screen/product_screen.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/search_dialog/search_dialog.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../Server/domains/domains.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';

class Wishlists extends StatefulWidget {
  const Wishlists({super.key});

  @override
  State<Wishlists> createState() => _WishlistsState();
}

class _WishlistsState extends State<Wishlists> {
  @override
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

  int _currentIndex = 0;
  bool isTablet = false;

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.favourite,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            showSearchDialog(context);
                          },
                          icon: Icon(
                            Icons.search_outlined,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          body: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              isTablet = true;
            } else {
              isTablet = false;
            }
            return Stack(
              children: [
                Consumer<FavouriteProvider>(
                    builder: (context, favoriteProvider, _) {
                  List<FavoriteItem> favoritesItems =
                      favoriteProvider.favoriteItems;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        favoritesItems.length != 0
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: favoritesItems.length,
                                itemBuilder: (context, index) {
                                  FavoriteItem item = favoritesItems[index];
                                  return favoriteCard(
                                    id: item.productId,
                                    name: item.name,
                                    categry: item.categoryID,
                                    removeProduct: () {
                                      favoriteProvider
                                          .removeFromFavorite(item.productId);
                                      setState(() {});
                                    },
                                    image: item.image,
                                  );
                                },
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .noew_products_favourites,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Icon(Icons.no_accounts_sharp)
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  );
                }),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget favoriteCard(
      {String image = "",
      String price = "",
      String name = "",
      int fav_id = 0,
      Function? removeProduct,
      int id = 0,
      int categry = 0}) {
    return InkWell(
      onTap: () {
        NavigatorFunction(
            context,
            ProductScreen(
                name: name,
                category_id: categry,
                image: image,
                product_id: id));
      },
      child: Padding(
        padding: isTablet
            ? EdgeInsets.only(right: 40, left: 40, top: 20)
            : EdgeInsets.only(right: 15, left: 15, top: 20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: isTablet ? 550 : 220,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      blurRadius: 5,
                    ),
                  ],
                  color: Color(0xffF6F6F6)),
              child: Container(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: isTablet ? 550 : 220,
                  width: double.infinity,
                ),
                height: isTablet ? 550 : 220,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Visibility(
                    // visible:
                    //     ROLEID == "3" && widget.SIZES!.length != 0 ? true : false,
                    child: InkWell(
                      onTap: () {
                        NavigatorFunction(
                            context,
                            ProductScreen(
                                name: name,
                                category_id: categry,
                                image: image,
                                product_id: id));
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Center(
                                child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.black,
                              size: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                            color:
                                                                Colors.grey)),
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
                                                    bool isFavorite =
                                                        favoriteProvider
                                                            .isProductFavorite(
                                                                id);
                                                    if (isFavorite) {
                                                      await favoriteProvider
                                                          .removeFromFavorite(
                                                              id);
                                                      Fluttertoast.showToast(
                                                        msg: AppLocalizations
                                                                .of(context)!
                                                            .fav_deleted_successfully,
                                                      );
                                                    } else {
                                                      final newItem =
                                                          FavoriteItem(
                                                        productId: id,
                                                        categoryID: categry,
                                                        name: name,
                                                        image: image,
                                                      );
                                                      await favoriteProvider
                                                          .addToFavorite(
                                                              newItem);
                                                      Fluttertoast.showToast(
                                                        msg: AppLocalizations
                                                                .of(context)!
                                                            .fav_added_successfully,
                                                      );
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
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
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 35,
                        width: 35,
                        child: Center(
                          child: Consumer<FavouriteProvider>(
                            builder: (context, favoriteProvider, _) {
                              bool isFavorite =
                                  favoriteProvider.isProductFavorite(id);
                              return Image.asset(
                                isFavorite
                                    ? "assets/images/in_favorite.png"
                                    : "assets/images/add_to_favorite.png",
                                height: 27,
                                width: 27,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
