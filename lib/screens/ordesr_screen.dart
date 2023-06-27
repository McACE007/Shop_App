import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer_widget.dart';
import '../widgets/order_item_widget.dart';

import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = "/orders-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Your Orders",
        ),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.countOrders,
                  itemBuilder: (_, i) {
                    return OrderItemWidget(
                      orderId: orders.orderItems[i].id,
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("Something went wrong."),
              );
            }
          }),
    );
  }
}
