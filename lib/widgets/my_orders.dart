import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/order.dart';

class MyOrdersWidget extends StatefulWidget {
  const MyOrdersWidget({super.key});

  @override
  State<MyOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<MyOrdersWidget> {
  List<Order> _orders = []; // Replace this with your actual data fetching logic

  @override
  void initState() {
    super.initState();

    firebaseController.onOrderChanged.listen((value) => fillAllOrders(value));

    // Fetch orders when the widget is initialized
    firebaseController.getAllOrders().then((value) => fillAllOrders(value));
  }

  void fillAllOrders(List<Order> orderList) {
    setState(() {
      _orders = orderList
          .where((element) =>
      element.accountName == signInController.currentUser!.displayName)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Column(children: [
        const Text("My Orders"),
        ListView.builder(
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${_orders[index].cocktail.name} x${_orders[index].amount}"),
                subtitle: Text(_orders[index].status),
              );
            }),
      ])),
    );
  }
}
