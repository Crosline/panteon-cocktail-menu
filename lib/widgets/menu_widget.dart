import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/widgets/product-card.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Menu', 
          style: Theme.of(context).textTheme.headlineLarge),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              children: List.generate(5, (index) {
                return ProductCard(
                  title: 'Product $index',
                  image: 'assets/images/panteon.png',
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
