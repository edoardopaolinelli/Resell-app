import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts(context)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ProductsScreen',
          style: GoogleFonts.ptSans(
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Show only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show all'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              value: cart.objects.length.toString(),
              color: Colors.red,
              child: ch as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : ProductsGrid(showFavorites: _showFavoritesOnly),
    );
  }
}
