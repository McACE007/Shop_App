import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products_provider.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Consumer<ProductItem>(
      builder: (context, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          footer: GridTileBar(
            title: FittedBox(
              child: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(auth.token, auth.userId);
              },
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                cart.addItems(
                  product.id,
                  product.title,
                  product.price,
                  product.imageUrl,
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Item added to cart!"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            ),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder:
                    const AssetImage('assets/images/image_placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
