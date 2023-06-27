import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = "/user-products-screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      drawer: const AppDrawerWidget(),
      appBar: AppBar(
        title: const Text("Manage Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    UserProductItem(
                      productData.items.toList()[i].id,
                      productData.items.toList()[i].title,
                      productData.items.toList()[i].imageUrl,
                    ),
                    const Divider(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
