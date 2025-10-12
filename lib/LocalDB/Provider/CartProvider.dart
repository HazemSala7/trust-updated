import 'dart:convert';
import 'package:flutter/material.dart';
import '../DataBase/DataBase.dart';
import '../Models/CartItem.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  CartDatabaseHelper _dbHelper = CartDatabaseHelper();

  List<CartItem> get cartItems => _cartItems;
  int get cartItemsCount => _cartItems.length;

  CartProvider() {
    _init();
  }

  Future<void> _init() async {
    _cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    final existingIndex = _cartItems
        .indexWhere((cartItem) => cartItem.productId == item.productId);

    if (existingIndex != -1) {
      if (item.color_en == '') {
        final existingSize = _cartItems.indexWhere((cartItem) =>
            cartItem.productId == item.productId &&
            cartItem.size_en == item.size_en);
        if (existingSize != -1) {
          _cartItems[existingSize].quantity += item.quantity;
          await _dbHelper.updateCartItem(_cartItems[existingSize]);
        } else {
          await _dbHelper.insertCartItem(item);
          _cartItems.add(item);
        }
      } else {
        if (_cartItems[existingIndex].color_en == "") {
          _cartItems[existingIndex].quantity += item.quantity;
          await _dbHelper.updateCartItem(_cartItems[existingIndex]);
        } else {
          await _dbHelper.insertCartItem(item);
          _cartItems.add(item);
        }
      }
    } else {
      await _dbHelper.insertCartItem(item);
      _cartItems.add(item);
    }
    _cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  Future<void> removeFromCart(CartItem item) async {
    await _dbHelper.deleteCartItem(item.id!);
    _cartItems.remove(item);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear(); // Clear the cart items in memory
    await _dbHelper.clearCart(); // Clear the cart items from the local database
    notifyListeners(); // Notify the listeners about the change
  }

  void updateCartItem(CartItem item) async {
    await _dbHelper.updateCartItem(item);
    // Refresh _cartItems with the latest data from the database
    _cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  Future<CartItem?> getCartItemByProductId(int productId) async {
    return await CartDatabaseHelper().getCartItemByProductId(productId);
  }

  List<Map<String, dynamic>> getProductsArray() {
    List<Map<String, dynamic>> productsArray = [];

    for (CartItem item in _cartItems) {
      Map<String, dynamic> productData = {
        'product_id': item.productId,
        'name_ar': item.name_ar,
        'name_en': item.name_en,
        'image': item.image,
        'size_ar': item.size_ar,
        'size_en': item.size_en,
        'size_id': item.size_id,
        'color_ar': item.color_ar,
        'color_en': item.color_en,
        'notes': item.notes,
        'sizes_en': item.sizes_en,
        'sizes_ar': item.sizes_ar,
        'quantity': item.quantity,
      };
      productsArray.add(productData);
    }

    return productsArray;
  }
}
