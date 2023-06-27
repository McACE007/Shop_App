import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';

class OrderItemWidget extends StatefulWidget {
  final String orderId;
  const OrderItemWidget({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false);
    final selectedOrder = orders.findOrderById(widget.orderId);

    return Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "\$${selectedOrder.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(selectedOrder.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                (_expanded ? Icons.expand_less : Icons.expand_more),
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
                height: min(selectedOrder.products.length * 20 + 5, 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListView(
                  children: selectedOrder.products
                      .map(
                        (product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${product.quantity.toInt()}x \$${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                )),
        ],
      ),
    );
  }
}
