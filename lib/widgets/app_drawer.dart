import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            AppBar(
              backgroundColor:
                  const Color.fromRGBO(255, 215, 0, 1).withOpacity(0.7),
              title: const Text('Menù'),
              automaticallyImplyLeading: false,
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: const Text('Shop', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              hoverColor: Colors.white70,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.white,
              ),
              title:
                  const Text('Orders', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: const Text('Manage Products',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName),
            ),
            const SizedBox(height: 20),
            ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                            Provider.of<Authentication>(context, listen: false)
                                .logout();
                          },
                          child: const Text('Continue'),
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
