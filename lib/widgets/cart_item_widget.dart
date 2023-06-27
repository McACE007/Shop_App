import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItems extends StatelessWidget {
  final String productId;

  const CartItems(this.productId, {super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final selectedItem = cart.items[productId];

    return Dismissible(
      key: ValueKey(selectedItem!.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      secondaryBackground: Container(
        color: Colors.black,
        child: const Padding(
          padding: EdgeInsets.only(right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      background: Container(
        color: Theme.of(context).colorScheme.error,
      ),
      child: SizedBox(
        height: 100,
        child: Card(
          margin: const EdgeInsets.symmetric(
            vertical: 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.network(
                  height: 80,
                  width: 80,
                  selectedItem.imageUrl,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedItem.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${(selectedItem.price * selectedItem.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 35,
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(30, 30),
                            side: const BorderSide(color: Colors.red)),
                        onPressed: () {
                          cart.removeQById(productId);
                        },
                        icon: const Icon(
                          size: 20,
                          Icons.remove,
                          color: Colors.red,
                        ),
                        label: const Text(""),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        height: 30,
                        width: 30,
                        color: Colors.red,
                        child: FittedBox(
                          child: Text(
                            "${selectedItem.quantity.toInt()}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(25, 30),
                            side: const BorderSide(color: Colors.red)),
                        onPressed: () {
                          cart.addQById(productId);
                        },
                        icon: const Icon(
                          size: 20,
                          Icons.add,
                          color: Colors.red,
                        ),
                        label: const Text(""),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
