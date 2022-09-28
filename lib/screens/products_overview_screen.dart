import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductsOverviewScreen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == FilterOptions.favorites) {
                productsData.showFavoritesOnly();
              } else {
                productsData.showAll();
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FilterOptions.favorites,
                onTap: () {
                  //
                },
                child: const Text('Show only favorites'),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                onTap: () {
                  //
                },
                child: const Text('Show all'),
              ),
            ],
          ),
        ],
      ),
      body: const ProductsGrid(),
    );
  }
}
