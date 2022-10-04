import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            'Your Orders',
          ),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occurred'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, ordersData, child) => ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (context, index) =>
                        OrderItem(order: ordersData.orders[index]),
                  ),
                );
              }
            }
          }),
        )

        /* _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItem(order: ordersData.orders[index]),
            ), */
        );
  }
}
