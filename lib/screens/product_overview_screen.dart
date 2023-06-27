import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer_widget.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_grid_widget.dart';
import '../widgets/badge_widget.dart';

enum FilterOption {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawerWidget(),
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, ch) => BadgeC(
              value: cartData.countItems.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOption.favorites,
                      child: Text("Only Favorites"),
                    ),
                    const PopupMenuItem(
                      value: FilterOption.all,
                      child: Text("Show All"),
                    ),
                  ]),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              showFavorites: _showOnlyFavorites,
            ),
    );
  }
}
