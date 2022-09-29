import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Your Cart',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '${cart.totalAmount.toStringAsFixed(2)} €',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium!
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.objects.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clearCart();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.objects.length,
                itemBuilder: (context, index) => CartItem(
                  id: cart.objects.values.toList()[index].id,
                  productId: cart.objects.keys.toList()[index],
                  title: cart.objects.values.toList()[index].title,
                  price: cart.objects.values.toList()[index].price,
                  quantity: cart.objects.values.toList()[index].quantity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
