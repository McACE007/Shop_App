import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/ordesr_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/orders_provider.dart';
import './providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider("", '', []),
          update: (ctx, auth, previousProductProvider) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProductProvider?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders?.orderItems ?? [],
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ),
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
