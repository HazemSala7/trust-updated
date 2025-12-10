import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
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
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
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
          body: Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              final List<CartItem> cartItems = cartProvider.cartItems;
              return _cartBody(
                cartItems: cartItems,
                cartProvider: cartProvider,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _cartBody({
    required List<CartItem> cartItems,
    required CartProvider cartProvider,
  }) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  // Header image
                  SizedBox(
                    height: mediaQuery.size.height * 0.2,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/Group.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  // White body container
                  Container(
                    height: mediaQuery.size.height * 0.8,
                    width: double.infinity,
                    color: Colors.white,
                    child: Visibility(
                      visible: cartItems.isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Notes
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 50,
                              right: 50,
                              bottom: 10,
                            ),
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: TextField(
                                maxLines: 5,
                                controller: notesController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 67, 67, 67),
                                    fontSize: 15,
                                  ),
                                  hintText:
                                      AppLocalizations.of(context)!.notes,
                                ),
                              ),
                            ),
                          ),

                          // Divider
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 15,
                            ),
                            child: Container(
                              height: 1,
                              color: const Color.fromARGB(255, 217, 217, 217),
                              width: double.infinity,
                            ),
                          ),

                          // Summary + Send order button
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.you_have} ${cartItems.length} ${AppLocalizations.of(context)!.products}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
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
                                          builder: (BuildContext context) {
                                            return  LoadingWidget(
                                              heightLoading: 50,
                                            );
                                          },
                                        );
                                        addOrder(
                                          context,
                                          notesController.text,
                                        );
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Center card with cart items
              Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  left: 25,
                  bottom: 70,
                ),
                child: Container(
                  height: mediaQuery.size.height * 0.65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: cartItems.isEmpty
                      ? SizedBox(
                          height: mediaQuery.size.height,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.empty_cart,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Image.asset(
                                "assets/images/empty-cart.png",
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartItems.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            final CartItem item = cartItems[index];
                            return CartItemCard(
                              item: item,
                              removeProduct: () {
                                cartProvider.removeFromCart(item);
                                setState(() {});
                                // If you open a dialog before removing,
                                // this pop will close that dialog.
                                Navigator.pop(context);
                              },
                              cartProvider: cartProvider,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),

        // AppBar overlay
         AppBarWidget(
          logo: false,
          back: true,
        ),
      ],
    );
  }
}
