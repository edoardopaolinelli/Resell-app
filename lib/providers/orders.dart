import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cart_object.dart';

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
  final String authenticationToken;

  Orders(this.authenticationToken, this._orders);

  List<OrderObject> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authenticationToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<OrderObject> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderObject(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((cartObject) => CartObject(
                    id: cartObject['id'],
                    title: cartObject['title'],
                    quantity: cartObject['quantity'],
                    price: cartObject['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartObject> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://resell-app-861f2-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authenticationToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cartProduct) => {
                      'id': cartProduct.id,
                      'title': cartProduct.title,
                      'quantity': cartProduct.quantity,
                      'price': cartProduct.price,
                    })
                .toList(),
          }));
      _orders.add(
        OrderObject(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
