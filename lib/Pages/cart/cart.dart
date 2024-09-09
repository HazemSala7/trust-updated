import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Components/loading_widget/loading_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/cart/cart_item.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../Components/drawer_widget/drawer_widget.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  TextEditingController NotesController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerWell(
            Refresh: () {
              setState(() {});
            },
          ),
          body: Consumer<CartProvider>(builder: (context, cartProvider, _) {
            List<CartItem> cartItems = cartProvider.cartItems;
            return cartMethod(cartItems: cartItems, cartProvider: cartProvider);
          }),
        ),
      ),
    );
  }

  Widget cartMethod({List<CartItem>? cartItems, CartProvider? cartProvider}) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      // Container(
                      //   height: MediaQuery.of(context).size.height * 0.2,
                      //   width: double.infinity,
                      //   color: Colors.red,
                      // ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/Group.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: double.infinity,
                        color: Colors.white,
                        child: Visibility(
                          visible: cartItems!.length == 0 ? false : true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 50, right: 50, bottom: 10),
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    maxLines: 5,
                                    controller: NotesController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 67, 67, 67),
                                          fontSize: 15),
                                      hintText:
                                          AppLocalizations.of(context)!.notes,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 15),
                                child: Container(
                                  height: 1,
                                  color:
                                      const Color.fromARGB(255, 217, 217, 217),
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.you_have} ${cartItems!.length} ${AppLocalizations.of(context)!.products}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        ButtonWidget(
                                            name: AppLocalizations.of(context)!
                                                .send_order,
                                            height: 40,
                                            width: 150,
                                            BorderColor: MAIN_COLOR,
                                            FontSize: 16,
                                            OnClickFunction: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return LoadingWidget(
                                                      heightLoading: 50);
                                                },
                                              );
                                              addOrder(context,
                                                  NotesController.text);
                                            },
                                            BorderRaduis: 20,
                                            ButtonColor: MAIN_COLOR,
                                            NameColor: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 25, left: 25, bottom: 70),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: cartItems.length == 0
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.empty_cart,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Image.asset(
                                    "assets/images/empty-cart.png",
                                    height: 40,
                                    width: 40,
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: cartItems.length,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (BuildContext context, int index) {
                                CartItem item = cartItems[index];
                                return CartItemCard(
                                    item: item,
                                    removeProduct: () {
                                      cartProvider!.removeFromCart(item);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    cartProvider: cartProvider);
                              }),
                    ),
                  )
                ],
              ),
            ),
          ),
          AppBarWidget(
            logo: false,
            back: true,
          )
        ],
      ),
    );
  }
}
