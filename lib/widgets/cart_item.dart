import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resell_app/screens/product_detail_screen.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete the product?',
              style: GoogleFonts.ptSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure to delete the product from the cart?',
              style: GoogleFonts.ptSans(
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeObject(productId);
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 35,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onDoubleTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productId,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              title: Text(title),
              subtitle:
                  Text('Total: ${(price * quantity).toStringAsFixed(2)} €'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
    );
  }
}


/* child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),*/