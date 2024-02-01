import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/controllers/navigation_controller.dart';
import 'package:panteon_cocktail_menu/widgets/admin_page/cocktail_settings.dart';
import 'package:panteon_cocktail_menu/widgets/sized_divider.dart';

import '../widgets/admin_page/admin_settings.dart';
import '../widgets/admin_page/bar_settings.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  static Builder getAdminLeading() => Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationController.pop(context), //() => SideBar.Open(context),
        );
      }
  );

  @override
  Widget build(BuildContext context) { {
      return Form(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Admin Settings"),
              leading: getAdminLeading(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: const [
                  BarSettingsWidget(),
                  SizedDivider(vertical: 20.0),
                  AdminSettingsWidget(),
                  SizedDivider(vertical: 20.0),
                  CocktailSettingsWidget()
                ],
              ),
            ),
          )
      );
    }
  }
}