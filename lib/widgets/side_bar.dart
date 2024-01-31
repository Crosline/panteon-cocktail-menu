import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/pages/onboarding_page.dart';

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
                onTap: () { },
              ),
            const Divider(),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () {
                signInController.signOut();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const OnboardingPage();
                      },
                    )
                );
              },
            )
          ],
          ),
      ),
    );
  }
}