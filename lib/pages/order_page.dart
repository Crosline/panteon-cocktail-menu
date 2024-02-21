import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/order.dart';
import 'package:panteon_cocktail_menu/widgets/loading_widget.dart';
import 'package:panteon_cocktail_menu/widgets/orders_page/order_card.dart';
import 'package:panteon_cocktail_menu/widgets/sized_divider.dart';

import '../controllers/navigation_controller.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  static Builder getOrderLeading() => Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationController.pop(context),
        );
      }
  );
  

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends LoadingWidgetState<OrderPage> {
  List<Widget> _orders = <Widget>[];

  @override
  void initState() {
    firebaseController.getAllOrders().then(turnOrdersToWidgets);
    firebaseController.onOrderChanged.listen(turnOrdersToWidgets);

    super.initState();
  }


  void turnOrdersToWidgets(List<Order> orders) {
    isLoading = false;
    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < orders.length; i++) {
      widgets.add(OrderCard(order: orders[i]));
      widgets.add(const SizedDivider());
    }
    setState(() {
      _orders = widgets;
    });
  }


  @override
  Widget build(BuildContext context) {
    return buildLoading(Form(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Orders"),
            leading: OrderPage.getOrderLeading(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: _orders,
            ),
          ),
        )
    ));
  }
}