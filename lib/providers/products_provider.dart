import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/edit_product_model.dart';
import '../models/http.exception.dart';

class ProductItem with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/favorite/$id.json?auth=$token";
    final response = await http.put(Uri.parse(url),
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<ProductItem> _items = [];

  List<ProductItem> get items {
    return [..._items];
  }

  List<ProductItem> get favoritesItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  ProductItem findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      url =
          "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/favorite.json?auth=$authToken";
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<ProductItem> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(ProductItem(
          id: productId,
          title: productData["title"],
          price: double.parse(productData["price"]),
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          isFavorite: favoriteData?[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(ProductTemp pt) async {
    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken";
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          "title": pt.title,
          "price": pt.price.toString(),
          "imageUrl": pt.imageUrl,
          "description": pt.description,
        }));
    _items.add(ProductItem(
      title: pt.title,
      price: pt.price,
      imageUrl: pt.imageUrl,
      description: pt.description,
      id: json.decode(response.body)['name'],
    ));
    notifyListeners();
  }

  Future<void> updateProduct(ProductTemp pt) async {
    final productIndex = _items.indexWhere((product) => product.id == pt.id);
    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/products/${pt.id}.json?auth=$authToken";
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': pt.title,
          'price': pt.price.toString(),
          'imageUrl': pt.imageUrl,
          'descripton': pt.description,
        }));
    _items[productIndex] = ProductItem(
      description: pt.description,
      imageUrl: pt.imageUrl,
      price: pt.price,
      title: pt.title,
      id: pt.id,
      isFavorite: pt.isFavorite,
    );
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken";
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    ProductItem? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete the product.");
    }
    existingProduct = null;
  }
}
