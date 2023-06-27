import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String imageUrl;
  final String title;
  final double quantity;
  final double price;

  CartItem({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get countItems {
    return _items.length;
  }

  void removeQById(String id) {
    if (_items[id]!.quantity == 1) {
      return;
    }
    _items.update(
      id,
      (old) => CartItem(
        id: old.id,
        title: old.title,
        quantity: old.quantity - 1,
        price: old.price,
        imageUrl: old.imageUrl,
      ),
    );
    notifyListeners();
  }

  void addQById(String id) {
    _items.update(
      id,
      (old) => CartItem(
        id: old.id,
        title: old.title,
        quantity: old.quantity + 1,
        price: old.price,
        imageUrl: old.imageUrl,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (old) => CartItem(
          id: old.id,
          title: old.title,
          quantity: old.quantity - 1,
          price: old.price,
          imageUrl: old.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
      (productId, cartItem) {
        total = cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  void addItems(
    String productId,
    String title,
    double price,
    String imgUrl,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (old) => CartItem(
          id: old.id,
          title: old.title,
          quantity: old.quantity + 1,
          price: old.price,
          imageUrl: old.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imgUrl,
        ),
      );
    }
    notifyListeners();
  }
}
