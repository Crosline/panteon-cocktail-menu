import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/widgets/product-card.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Text('Menu'),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              children: List.generate(5, (index) {
                return ProductCard(
                  title: 'Product $index',
                  price: '\$10',
                  image: 'assets/images/cocktail.jpg',
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
