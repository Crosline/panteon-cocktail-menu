import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/controllers/navigation_controller.dart';
import 'package:panteon_cocktail_menu/main.dart';

class AdminPage extends StatefulWidget {
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
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool _isLoading = true;
  late String? _adminToUpdate;

  @override
  void initState() {
    firebaseController.getBarSettings().then((newBarSettings) {
      barSettings = newBarSettings;
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void _submit() {
    setState(() {
      _isLoading = true;
    });

    firebaseController.setBarSettings(barSettings).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _updateAdmin(bool isAdd) {
    setState(() {
      _isLoading = true;
    });

    if (isAdd) {
      firebaseController.addAdminUser(_adminToUpdate).then((value) => {
        setState(() {
          _isLoading = false;
        })
      });
    } else {
      firebaseController.removeAdminUser(_adminToUpdate).then((value) => {
        setState(() {
          _isLoading = false;
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Form(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Admin Settings"),
              leading: AdminPage.getAdminLeading(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Admin Settings',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: barSettings.title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Panteon CBO Cocktail',
                      labelText: "Bar Name",
                    ),
                    onChanged: (value) { barSettings.title = value; },
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                          value: barSettings.isOpen,
                        onChanged: (value) {
                            setState(() {
                              barSettings.isOpen = value!;
                            });
                          },
                      ),
                      const Text("Is Bar Open")
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'example@panteon.games',
                      labelText: "CBO Email",
                    ),
                    onChanged: (value) { _adminToUpdate = value; },
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () { _updateAdmin(true); },
                        child: const Text('Add'),
                      ),
                      const SizedBox(width: 80),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () { _updateAdmin(false); },
                        child: const Text('Remove'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      );
    }
  }

}