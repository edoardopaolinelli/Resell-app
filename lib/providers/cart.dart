import 'package:flutter/material.dart';

import '../models/cart_object.dart';

class Cart with ChangeNotifier {
  Map<String, CartObject> _objects = {};

  Map<String, CartObject> get objects {
    return {..._objects};
  }

  /*  int get ojectsCount {
    return _objects.length;
  } */

  double get totalAmount {
    double total = 0.0;
    _objects.forEach((key, cartObject) {
      total += cartObject.quantity * cartObject.price;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_objects.containsKey(productId)) {
      _objects.update(
        productId,
        (cartObject) => CartObject(
          id: cartObject.id,
          title: cartObject.title,
          quantity: cartObject.quantity + 1,
          price: cartObject.price,
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
        ),
      );
    }
    notifyListeners();
  }
}
