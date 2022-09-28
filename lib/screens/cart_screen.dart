import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryTextTheme.titleMedium!.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Your Cart',
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.titleMedium!.color),
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
                        '${cart.totalAmount} €',
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
                        //
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
