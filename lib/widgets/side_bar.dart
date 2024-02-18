import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/controllers/navigation_controller.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/pages/admin_page.dart';
import 'package:panteon_cocktail_menu/pages/onboarding_page.dart';

import '../pages/order_page.dart';

class SideBar extends StatelessWidget {
  static const EdgeInsets allPadding = EdgeInsets.all(20);

  static Builder getCustomLeading() => Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(), //() => SideBar.Open(context),
          );
        }
    );

  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 5),
              child: Column(
                children: [
                  CircleAvatar(
                    foregroundImage: Image.network(signInController.currentUser!.photoUrl!).image,
                  ),
                  const SizedBox(height: 20),
                  Text(signInController.currentUser!.displayName!),
                  const Text("CBO"),
                ],
              ),
            ),
            ListTile(
              title: const Text("Cart"),
              onTap: () { },
            ),
            if(isAdmin)
              ListTile(
                title: const Text("Admin"),
                onTap: () => NavigationController.push(context, const AdminPage()),
              ),
            if(isAdmin)
              ListTile(
                title: const Text("Orders"),
                onTap: () => NavigationController.push(context, const OrderPage()),
              ),
            const Divider(),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () {
                signInController.signOut();
                NavigationController.replace(context, const OnboardingPage());
              },
            )
          ],
        ),
      ),
    );
  }
}