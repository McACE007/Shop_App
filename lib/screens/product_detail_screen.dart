import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Hero(
            tag: productId,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
          ),
          Text(loadedProduct.title),
          Text(loadedProduct.description),
        ],
      ),
    );
  }
}
