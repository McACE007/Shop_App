import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orderItems {
    return [..._orders];
  }

  int get countOrders {
    return _orders.length;
  }

  OrderItem findOrderById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/orders.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body);
    final List<OrderItem> loadedOrders = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                imageUrl: item['imageUrl'],
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> items, double total) async {
    final url =
        "https://shop-app-mc-3254c-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId/orders.json?auth=$authToken";
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": items
              .map((item) => {
                    'id': item.id,
                    'title': item.title,
                    'quantity': item.quantity,
                    'price': item.price,
                    'imageUrl': item.imageUrl,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: items,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
