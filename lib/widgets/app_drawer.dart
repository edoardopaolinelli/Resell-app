import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              title: Text(
                'Menù',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                ),
              ),
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
              title: Text(
                'Shop',
                style: GoogleFonts.ptSans(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              hoverColor: Colors.white70,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.white,
              ),
              title: Text(
                'Orders',
                style: GoogleFonts.ptSans(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                'Manage Products',
                style: GoogleFonts.ptSans(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName),
            ),
            const SizedBox(height: 20),
            ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.ptSans(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure to logout?',
                        style: GoogleFonts.ptSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                            Provider.of<Authentication>(context, listen: false)
                                .logOut();
                          },
                          child: Text(
                            'Continue',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
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
