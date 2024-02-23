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
      List<Order> list = orderList
          .where((element) =>
              element.accountName == signInController.currentUser!.displayName)
          .where((element) => element.status != 'Completed')
          .toList();

      list.sort((a, b) => a.orderTime.compareTo(b.orderTime));
      _orders = list.take(6).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int count = width > 600
        ? width > 900
            ? width > 1200
                ? width > 1600
                    ? 8
                    : 6
                : 4
            : 3
        : 2;

    final TextStyle pendingStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(
            color: const Color.fromRGBO(255, 153, 0, 1),
            fontWeight: FontWeight.bold);

    final completedStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
        color: const Color.fromRGBO(0, 255, 81, 1),
        fontWeight: FontWeight.bold);
    final inProgressStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
        color: const Color.fromRGBO(255, 255, 0, 1),
        fontWeight: FontWeight.bold);

    final colorMap = {
      'pending': pendingStyle,
      'done': completedStyle,
      'in progress': inProgressStyle
    };
    if (_orders.isEmpty) {
      return Container();
    }

    return Column(children: [
      Text('My Orders', style: Theme.of(context).textTheme.headlineLarge),
      GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: count,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        childAspectRatio: (width / count) / 90,
        children: _orders
            .map((order) => Padding(
                  padding: const EdgeInsets.only(
                      top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outline)),
                    title: Row(children: [
                      Text(
                        order.cocktail.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Spacer(),
                      Text("x${order.amount}",
                          style: Theme.of(context).textTheme.labelSmall)
                    ]),
                    subtitle: Text(
                      order.status,
                      style: colorMap[order.status],
                    ),
                  ),
                ))
            .toList(),
      )
    ]);
  }
}
