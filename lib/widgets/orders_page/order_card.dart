import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.accountName, style: const TextStyle(fontSize: 16)),
                Text(order.status, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${order.amount}x", style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 30),
                    Text(order.cocktail.name, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screen_width * 0.5,
                  child: Text(order.cocktail.recipe,
                      style: const TextStyle(fontSize: 14),
                      softWrap: true
                  ),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(width: 125, child: ElevatedButton(onPressed: () => { firebaseController.updateOrderStatus(order, "in progress") }, child: const Text("Take Order"))),
                const SizedBox(height: 10),
                SizedBox(width: 125, child: ElevatedButton(onPressed: () => { firebaseController.updateOrderStatus(order, "done") }, child: const Text("Done"))),
                const SizedBox(height: 10),
                SizedBox(width: 125, child: ElevatedButton(onPressed: () => { firebaseController.updateOrderStatus(order, "pending") }, child: const Text("Cancel"))),
                const SizedBox(height: 20),
                SizedBox(width: 125, child: ElevatedButton(onPressed: () => { firebaseController.removeOrder(order) }, child: const Text("Delete"))),
              ],
            ),
          ],
        ),
      ),
    );
  }

}