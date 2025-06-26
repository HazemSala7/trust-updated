import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/CartItem.dart';
import '../Models/FavoriteItem.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();
  static final int dbVersion = 15;

  factory CartDatabaseHelper() => _instance;

  CartDatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<CartItem?> getCartItemByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return CartItem.fromJson(maps.first);
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'well.db');

    return await openDatabase(
      path,
      version: dbVersion,
      onUpgrade: _onUpgrade,
      onCreate: (db, version) async {
        await _createDb(db);
      },
    );
  }

  Future<void> _createDb(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        size_id INTEGER NOT NULL,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        size_ar TEXT NOT NULL,
        size_en TEXT NOT NULL,
        color_en TEXT NOT NULL,
        color_ar TEXT NOT NULL,
        notes TEXT NOT NULL,
        categoryID INTEGER NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        selectedSizeIndex INTEGER NOT NULL,
        sizes_en TEXT NOT NULL,
        sizes_ar TEXT NOT NULL,
        sizesIDs TEXT NOT NULL,
        colorsNamesEN TEXT NOT NULL,
        colorsNamesAR TEXT NOT NULL,
        color_id INTEGER NOT NULL,
        colorsImages TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        categoryID INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Drop existing tables
    await db.execute('DROP TABLE IF EXISTS cart');
    await db.execute('DROP TABLE IF EXISTS favorites');

    // Recreate tables with updated schema
    await _createDb(db);
  }

  Future<FavoriteItem?> getFavoriteItemByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return FavoriteItem.fromJson(maps.first);
  }

  Future<int> insertFavoriteItem(FavoriteItem item) async {
    final db = await database;
    return await db!.insert('favorites', item.toJson());
  }

  Future<List<FavoriteItem>> getFavoriteItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('favorites');
    return List.generate(
      maps.length,
      (i) => FavoriteItem.fromJson(maps[i]),
    );
  }

  Future<void> deleteFavoriteItem(int id) async {
    final db = await database;
    await db!.delete('favorites', where: 'productId = ?', whereArgs: [id]);
  }

  // Method to clear the cart database
  Future<void> clearCart() async {
    final db = await database;
    await db!.delete('cart'); // Delete all records from the 'cart' table
  }

  Future<int> insertCartItem(CartItem item) async {
    final db = await database;
    return await db!.insert('cart', {
      'productId': item.productId,
      'name_ar': item.name_ar,
      'name_en': item.name_en,
      'color_en': item.color_en,
      'color_ar': item.color_ar,
      'notes': item.notes,
      'categoryID': item.categoryID,
      'image': item.image,
      'selectedSizeIndex': item.selectedSizeIndex,
      'size_ar': item.size_ar,
      'size_en': item.size_en,
      'color_id': item.color_id,
      'quantity': item.quantity,
      'size_id': item.size_id,
      'sizes_en': item.sizes_en.join(','),
      'sizes_ar': item.sizes_ar.join(','),
      'sizesIDs': item.sizesIDs.join(','),
      'colorsNamesEN': item.colorsNamesEN.join(','),
      'colorsNamesAR': item.colorsNamesAR.join(','),
      'colorsImages': item.colorsImages.join(','),
    });
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('cart');
    return List.generate(
      maps.length,
      (i) => CartItem.fromJson(maps[i]),
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db!.update(
      'cart',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
