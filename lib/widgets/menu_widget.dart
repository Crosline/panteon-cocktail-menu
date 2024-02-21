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
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        children: <Widget>[
          Text('Menu', style: Theme.of(context).textTheme.headlineLarge),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              childAspectRatio: 0.6,
              crossAxisCount:  width > 600 ? width > 900 ? width > 1200 ? width > 1600 ? 8 : 6 : 4 : 3 : 2,
              scrollDirection: Axis.vertical,
              children: _products),
            ),
        ],
      ),
    );
  }
}
