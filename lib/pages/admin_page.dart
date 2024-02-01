import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/controllers/navigation_controller.dart';
import 'package:panteon_cocktail_menu/main.dart';

import '../models/cocktail.dart';

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

  Cocktail? _selectedCocktail;
  String? _newCocktailName = "";
  Map<String, dynamic> _cocktailMap = <String, dynamic>{};

  @override
  void initState() {
    firebaseController.getBarSettings().then((newBarSettings) {
      barSettings = newBarSettings;

      _updateCocktailMap();

    });

    super.initState();
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }
  void _updateCocktailMap() {
    firebaseController.getCocktailMap().then((cocktailMap) {
      _cocktailMap = cocktailMap;

      String? firstCocktail = cocktailMap.keys.firstOrNull;
      if (firstCocktail != null) {
        _selectedCocktail = Cocktail.fromJsonMap(cocktailMap[firstCocktail]);
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void _submit() {
    _startLoading();

    firebaseController.setBarSettings(barSettings).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _updateAdmin(bool isAdd) {
    _startLoading();

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
              child: ListView(
                children: [
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
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  if (_selectedCocktail != null)
                    Column(
                      children: [
                        DropdownMenu(
                          initialSelection: _selectedCocktail!.name,
                          onSelected: _onCocktailSelected,
                          dropdownMenuEntries: _cocktailMap.keys.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry(value: value, label: value);
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _selectedCocktail!.description,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'acinin tatli tebessumu',
                            labelText: "Description",
                          ),
                          onChanged: (value) { _selectedCocktail!.description = value; },
                          validator: _validate,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _selectedCocktail!.price,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'acinin tatli tebessumu',
                            labelText: "Price",
                          ),
                          onChanged: (value) { _selectedCocktail!.price = value; },
                          validator: _validate,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: _updateCocktail,
                              child: const Text('Update'),
                            ),
                            const SizedBox(width: 80),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(90, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: _removeCocktail,
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Bedroom Ecstasy',
                      labelText: "New Cocktail Name",
                    ),
                    onChanged: (value) { _newCocktailName = value; },
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: _addNewCocktail,
                    child: const Text('Add New Cocktail'),
                  ),
                ],
              ),
            ),
          )
      );
    }
  }


  void _updateCocktail() {
    if (_selectedCocktail == null) return;
    _startLoading();

    firebaseController.setCocktail(_selectedCocktail!).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onCocktailSelected(String? value) {
    var currentCocktail = _cocktailMap[value] as Cocktail;

    setState(() {
      _selectedCocktail = currentCocktail;
    });
  }

  void _addNewCocktail() {
    var newCocktail = Cocktail(name: _newCocktailName!, description: "desc", price: "mangir");
    _startLoading();
    firebaseController.setCocktail(newCocktail).then((value) {
      firebaseController.getCocktailMap().then((cocktailMap) {
        _updateCocktailMap();
      });
    });
  }

  void _removeCocktail() {
    _startLoading();
    firebaseController.removeCocktail(_selectedCocktail!).then((value) {

      _updateCocktailMap();
    });
  }
}