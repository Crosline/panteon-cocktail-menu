import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/order.dart';

class MyOrdersWidget extends StatefulWidget {
  const MyOrdersWidget({super.key});

  @override
  State<MyOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<MyOrdersWidget> {
  List<String> orders = []; // Replace this with your actual data fetching logic

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget is initialized
  }

  void fetchOrders() {
    // firebaseController.getAllOrders().then((value) {
    //   setState(() {
    //     orders = value
    //         .where((element) =>
    //             element.accountName ==
    //             signInController.currentUser!.displayName)
    //         .toList();
    //   });
    // });

    orders = ["Order 1", "Order 2", "Order 3"];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(orders[index]),
        );
      },
    ));
  }
}
