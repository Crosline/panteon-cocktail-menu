import 'dart:ui';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key, required this.title, required this.price, required this.image})
      : super(key: key);
  final String title;
  final String price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Theme.of(context).colorScheme.outline)),
        child: Column(
          children: <Widget>[
            // Image.asset(
            //   image,
            //   fit: BoxFit.cover,
            //   height: 100,
            //   width: double.infinity,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                price,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Spacer(),
            const Text("Lime, Tequila, Triple Sec"),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Order'),
                ),
              ),
            )
          ],
        ));
  }
}
