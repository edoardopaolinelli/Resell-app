import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  final String authenticationToken;
  final String userId;

  ProductsProvider(this.authenticationToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authenticationToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final favoriteUrl = Uri.parse(
          'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authenticationToken');
      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authenticationToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authenticationToken');
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[productIndex];
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authenticationToken');
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    existingProduct = null;
  }
}
