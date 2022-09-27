import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_bag),
          color: Colors.deepOrange,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite),
          color: Colors.deepOrange,
        ),
        backgroundColor: Colors.black45,
        title: Text(
          title,
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
            arguments: id,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
