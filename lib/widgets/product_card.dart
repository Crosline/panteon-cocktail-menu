
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.title, required this.image})
      : super(key: key);
  final String title;
  final String image;

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
                  image,
                  fit: BoxFit.contain,
                  height: 100,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Spacer(),
            const Text("Lime, Tequila, Triple Sec"),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () {},
                  child: const Text('Order'),
                ),
              ),
            )
          ],
        ));
  }
}
