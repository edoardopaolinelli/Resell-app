import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final chosenProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${chosenProduct.title} Details'),
      ),
      body: Column(
        children: [
          Image.network(
            chosenProduct.imageUrl,
            fit: BoxFit.cover,
          ),
          Text(chosenProduct.title),
          Text(chosenProduct.price.toString()),
          Text(chosenProduct.description),
        ],
      ),
    );
  }
}
