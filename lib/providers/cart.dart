import 'package:flutter/material.dart';

import '../models/cart_object.dart';

class Cart with ChangeNotifier {
  Map<String, CartObject> _objects = {};

  Map<String, CartObject> get objects {
    return {..._objects};
  }

  double get totalAmount {
    double total = 0.0;
    _objects.forEach((key, cartObject) {
      total += cartObject.quantity * cartObject.price;
    });
    return total;
  }

  void addObject(
      String productId, double price, String title, String imageUrl) {
    if (_objects.containsKey(productId)) {
      _objects.update(
        productId,
        (cartObject) => CartObject(
          id: cartObject.id,
          title: cartObject.title,
          quantity: cartObject.quantity + 1,
          price: cartObject.price,
          imageUrl: cartObject.imageUrl,
        ),
      );
    } else {
      _objects.putIfAbsent(
        productId,
        () => CartObject(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleObject(String productId) {
    if (!_objects.containsKey(productId)) {
      return;
    }
    if (_objects[productId]!.quantity > 1) {
      _objects.update(
        productId,
        (cartObject) => CartObject(
          id: cartObject.id,
          title: cartObject.title,
          quantity: cartObject.quantity - 1,
          price: cartObject.price,
          imageUrl: cartObject.imageUrl,
        ),
      );
    } else {
      _objects.remove(productId);
    }
    notifyListeners();
  }

  void removeObject(String productId) {
    _objects.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _objects = {};
    notifyListeners();
  }
}
