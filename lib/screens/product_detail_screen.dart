import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  TapDownDetails? _tapDownDetails;

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter == 1) return;
      _counter--;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _controller.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final chosenProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
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
        title: Text(
          chosenProduct.title,
          style: GoogleFonts.ptSans(
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
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
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onDoubleTapDown: (details) => _tapDownDetails = details,
              onDoubleTap: () {
                final position = _tapDownDetails!.localPosition;
                const double scale = 2.5;
                final x = -position.dx * (scale - 1);
                final y = -position.dy * (scale - 1);
                final zoomed = Matrix4.identity()
                  ..translate(x, y)
                  ..scale(scale);
                final end = _controller.value.isIdentity()
                    ? zoomed
                    : Matrix4.identity();
                _animation = Matrix4Tween(
                  begin: _controller.value,
                  end: end,
                ).animate(
                  CurveTween(curve: Curves.easeOut)
                      .animate(_animationController),
                );
                _animationController.forward(from: 0);
              },
              child: InteractiveViewer(
                transformationController: _controller,
                panEnabled: false,
                scaleEnabled: false,
                child: Hero(
                  tag: chosenProduct.id,
                  child: Image.network(
                    chosenProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chosenProduct.title,
                            style: GoogleFonts.ptSans(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      chosenProduct.description,
                      maxLines: 3,
                      style: GoogleFonts.ptSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      'Price: '
                      '${chosenProduct.price} €',
                      style: GoogleFonts.ptSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _decrementCounter,
                          child: Container(
                            height: 49,
                            width: 49,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '-',
                                style: GoogleFonts.ptSans(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 49,
                          width: 100,
                          child: Center(
                            child: Text(
                              '$_counter',
                              style: GoogleFonts.ptSans(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _incrementCounter,
                          child: Container(
                            height: 49,
                            width: 49,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '+',
                                style: GoogleFonts.ptSans(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          offset: const Offset(0, -3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.ptSans(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${chosenProduct.price * _counter} €',
                                style: GoogleFonts.ptSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              cart.addMultipleObject(
                                  chosenProduct.id,
                                  chosenProduct.price,
                                  chosenProduct.title,
                                  chosenProduct.imageUrl,
                                  _counter);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: GoogleFonts.ptSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
