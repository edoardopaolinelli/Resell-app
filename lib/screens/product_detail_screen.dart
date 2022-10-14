import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.grey.shade800),
              ),
              height: 300,
              width: double.infinity,
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
            const SizedBox(
              height: 10,
            ),
            Text(
              '${chosenProduct.price} €',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                chosenProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
