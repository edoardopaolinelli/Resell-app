import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'ResellApp',
        theme: ThemeData(
          colorSchemeSeed: Colors.amber,
          brightness: Brightness.light,
          useMaterial3: true,
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
        },
      ),
    );
  }
}
