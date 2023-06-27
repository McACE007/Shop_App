import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 209, 209, 209),
        appBar: AppBar(
          title: const Text("Your Cart"),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItems(cart.items.keys.toList()[i]);
              },
              itemCount: cart.countItems,
            )),
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(children: [
                  Row(
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(
                          "\$${cart.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OrderButton(cart: cart),
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
