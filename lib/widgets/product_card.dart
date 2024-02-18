import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/cocktail.dart';
import 'package:panteon_cocktail_menu/models/order.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.cocktail}) : super(key: key);
  final Cocktail cocktail;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;

  void _setOrder() {
    firebaseController
        .addNewOrder(Order(
            accountName: signInController.currentUser!.displayName!,
            cocktails: <Cocktail, int>{widget.cocktail: _quantity},
            orderTime: DateTime.now()))
        .then((value) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Order placed')))
            });
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Theme.of(context).colorScheme.outline)),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 30,
                child: Image.asset(
                  widget.cocktail.imageUrl,
                  fit: BoxFit.contain,
                  height: 100,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.cocktail.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Spacer(),
            Text(widget.cocktail.description),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton.outlined(
                          iconSize: 10,
                          constraints: const BoxConstraints(),
                          onPressed: _decrement,
                          icon: const Icon(Icons.remove),
                        ),
                        SizedBox.fromSize(
                            size: const Size(30, 30),
                            child: Center(
                                child: Text(
                              '$_quantity',
                              style: Theme.of(context).textTheme.titleLarge,
                            ))),
                        IconButton.outlined(
                          iconSize: 10,
                          constraints: const BoxConstraints(),
                          onPressed: _increment,
                          icon: const Icon(Icons.add),
                        ),
                      ]),
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: _setOrder,
                    child: const Text('Order'),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
