import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';
import '../providers/cart.dart';
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
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final authenticationData = Provider.of<Authentication>(
      context,
      listen: false,
    );
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(
          onPressed: () {
            cart.addObject(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Added product to cart!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber,
                  ),
                ),
                action: SnackBarAction(
                  label: 'CANCEL',
                  onPressed: () {
                    cart.removeSingleObject(product.id);
                  },
                ),
                duration: const Duration(
                  seconds: 3,
                ),
              ),
            );
          },
          icon: const Icon(Icons.shopping_bag),
          color: Colors.amber,
        ),
        trailing: Consumer<Product>(
          builder: (context, productValue, child) => IconButton(
            onPressed: () async {
              productValue
                  .toggleFavoriteStatus(authenticationData.token as String);
            },
            icon: Icon(product.isFavorite
                ? Icons.favorite
                : Icons.favorite_outline_sharp),
            color: Colors.amber,
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
