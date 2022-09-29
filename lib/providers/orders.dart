import 'package:flutter/material.dart';
import 'package:resell_app/models/cart_object.dart';

class OrderObject {
  final String id;
  final double amount;
  final List<CartObject> products;
  final DateTime dateTime;

  OrderObject({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderObject> _orders = [];

  List<OrderObject> get orders {
    return [..._orders];
  }

  void addOrder(List<CartObject> cartProducts, double total) {
    _orders.add(
      OrderObject(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
