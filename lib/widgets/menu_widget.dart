import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/cocktail.dart';
import 'package:panteon_cocktail_menu/widgets/product_card.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  List<ProductCard> _products = <ProductCard>[];

  @override
  void initState() {
    firebaseController.getCocktailMap().then((value) {
      var products = <ProductCard>[];

      for (var cocktailMap in value.values) {
        var cocktail = Cocktail.fromJsonMap(cocktailMap);
        if (!cocktail.isEnabled) continue;

        products.add(ProductCard(cocktail: cocktail));
      }

        setState(() {
          _products = products;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Menu', style: Theme.of(context).textTheme.headlineLarge),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              children: _products),
            ),
        ],
      ),
    );
  }
}
