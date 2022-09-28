import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_bag),
          color: Colors.deepOrange,
        ),
        trailing: Consumer<Product>(
          builder: (context, productValue, child) => IconButton(
            onPressed: () {
              productValue.toggleFavoriteStatus();
            },
            icon: Icon(product.isFavorite
                ? Icons.favorite
                : Icons.favorite_outline_sharp),
            color: Colors.deepOrange,
          ),
        ),
        backgroundColor: Colors.black45,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.5,
            color: Colors.grey.shade800,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
