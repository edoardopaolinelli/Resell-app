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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: SizedBox(
          height: 40,
          child: GridTileBar(
            backgroundColor: Colors.black38,
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
                  productValue.toggleFavoriteStatus(
                    authenticationData.token,
                    authenticationData.userId,
                  );
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline_sharp),
                color: Colors.amber,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
