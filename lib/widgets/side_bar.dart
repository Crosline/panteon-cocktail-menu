import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panteon_cocktail_menu/controllers/sign_in_controller.dart';
import 'package:panteon_cocktail_menu/main.dart';

class SideBar extends StatefulWidget {
  static const EdgeInsets allPadding = EdgeInsets.all(20);

  static Builder getCustomLeading() => Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(), //() => SideBar.Open(context),
          );
        }
    );

  SideBar({super.key});


  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
                    foregroundImage: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQDGQ55_znshhGDlxv5sDZz96tD3hxPc5j8CVWMKvJcw&s").image,
                  ),
                  const SizedBox(height: 20),
                  const Text("username"),
                ],
              ),
            ),
            const ListTile(
              title: Text("Item 1"),
            ),
            const ListTile(
              title: Text("Item 2"),
            ),
            if(isAdmin)
              const ListTile(
                title: Text("Admin"),
              ),
            if(!isSignedIn)
              ListTile(
                title: ElevatedButton(onPressed: () {
                  signInController.signIn();
                }, child: Text("Sign In")),
              )
            else
              ListTile(
                title: ElevatedButton(onPressed: () {
                  signInController.signOut();
                }, child: Text("Sign Out")),
              )
          ],
          ),
      ),
    );
  }
}