import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './screens/products_overview_screen.dart';
import './providers/authentication.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './screens/authentication_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Authentication(),
        ),
        ChangeNotifierProxyProvider<Authentication, ProductsProvider>(
          update: (context, authentication, previous) => ProductsProvider(
            authentication.token,
            authentication.userId,
            previous == null ? [] : previous.items,
          ),
          create: (context) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Authentication, Orders>(
          update: (context, authentication, previous) => Orders(
              authentication.token,
              authentication.userId,
              previous == null ? [] : previous.orders),
          create: (context) => Orders('', '', []),
        ),
      ],
      child: Consumer<Authentication>(
        builder: (context, authenticationData, _) => MaterialApp(
          title: 'ResellApp',
          theme: ThemeData(
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 30,
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
            ).copyWith(secondary: Colors.orange),
            brightness: Brightness.light,
            fontFamily: 'Lato',
          ),
          home: authenticationData.isAuthenticated
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authenticationData.automaticLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromRGBO(0, 255, 0, 1)
                                          .withOpacity(0.5),
                                      const Color.fromRGBO(255, 215, 0, 1)
                                          .withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: SpinKitFadingCircle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const AuthenticationScreen(),
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
