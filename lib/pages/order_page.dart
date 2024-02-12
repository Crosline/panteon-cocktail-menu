import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/widgets/menu_widget.dart';
import 'package:panteon_cocktail_menu/widgets/side_bar.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        leading: SideBar.getCustomLeading(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title:const Text("Menu"),
      ),
      body: const Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: MenuWidget()),
          ],
        ),
      ),
    );
  }

}