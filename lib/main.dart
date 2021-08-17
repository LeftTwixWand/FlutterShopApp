import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_sсreen.dart';
import './screens/product_detail_screen.dart';
import './providers/cart_provider.dart';
import './providers/authorization_provider.dart';
import './providers/products_provider.dart';
import './providers/orders_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthorizationProvider(),
        ),
        ChangeNotifierProxyProvider<AuthorizationProvider, OrdersProvider>(
          create: (_) => OrdersProvider(),
          update: (ctx, authorizationProvider, previousProductsState) =>
              previousProductsState!.update(
            authorizationProvider.token,
            previousProductsState.orders,
          ),
        ),
        ChangeNotifierProxyProvider<AuthorizationProvider, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (ctx, authorizationProvider, previousProductsState) =>
              previousProductsState!.update(
            authorizationProvider.token,
            authorizationProvider.userId,
            previousProductsState.items,
          ),
        ),
      ],
      child: Consumer<AuthorizationProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
