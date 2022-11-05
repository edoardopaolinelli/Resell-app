import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  final String? authenticationToken;
  final String? userId;

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

  Future<void> fetchAndSetProducts(BuildContext context,
      [bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authenticationToken$filterString');
    try {
      final response = await http.get(url);
      final databaseData = json.decode(response.body) as Map<String, dynamic>?;
      if (databaseData == null) {
        return;
      }
      final favoriteUrl = Uri.parse(
          'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authenticationToken');
      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];
      databaseData.forEach((productId, productData) {
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
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  Future<void> addProduct(BuildContext context, Product product) async {
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
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  Future<void> updateProduct(
      BuildContext context, String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
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
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  Future<void> deleteProduct(BuildContext context, String id) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[productIndex];
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authenticationToken');
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode > 399 && response.statusCode < 500) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Could not delete the product.',
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          });
    }
    existingProduct = null;
  }
}
