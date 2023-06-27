import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  const UserProductItem(this.productId, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: productId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
            onPressed: () async {
              try {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(productId);
              } catch (error) {
                scaffold.showSnackBar(const SnackBar(
                    content: Text(
                  "Deletion Failed!",
                  textAlign: TextAlign.center,
                )));
              }
            },
          ),
        ]),
      ),
    );
  }
}
