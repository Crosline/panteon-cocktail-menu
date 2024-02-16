import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/widgets/loading_widget.dart';
import 'package:panteon_cocktail_menu/widgets/sized_divider.dart';

import '../../main.dart';
import '../../models/cocktail.dart';
import '../../utils/validator.dart';

class CocktailSettingsWidget extends StatefulWidget {
  const CocktailSettingsWidget({super.key});

  @override
  LoadingWidgetState<CocktailSettingsWidget> createState() => _CocktailSettingsWidgetState();
}

class _CocktailSettingsWidgetState extends LoadingWidgetState<CocktailSettingsWidget> {
  Map<String, dynamic> _cocktailMap = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();

  Cocktail? _selectedCocktail;
  String? _newCocktailName;

  @override
  void initState() {
    _updateCocktailMap();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildLoading(
        Column(
          children: [
            if (_selectedCocktail != null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownMenu(
                        width: 200,
                        initialSelection: _selectedCocktail!.name,
                        onSelected: _onCocktailSelected,
                        dropdownMenuEntries: _cocktailMap.keys.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry(value: value, label: value);
                        }).toList(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(135, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _updateCocktail,
                            child: const Text('Update'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(135, 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _removeCocktail,
                            child: const Text('Remove'),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _selectedCocktail!.isEnabled,
                        onChanged: (value) { setState(() {
                          _selectedCocktail!.isEnabled = value!;
                        }); },
                      ),
                      const Text("Is Cocktail Enabled")
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: Key(_selectedCocktail!.description),
                    initialValue: _selectedCocktail!.description,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'acinin tatli tebessumu',
                      labelText: "Description",
                    ),
                    onChanged: (value) { _selectedCocktail!.description = value; },
                    validator: Validator.stringValidator,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: Key(_selectedCocktail!.recipe),
                    initialValue: _selectedCocktail!.recipe,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'acinin tatli tebessumu',
                      labelText: "Recipe",
                    ),
                    onChanged: (value) { _selectedCocktail!.recipe = value; },
                    validator: Validator.stringValidator,
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            const SizedDivider(vertical: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Bedroom Ecstasy',
                  labelText: "New Cocktail Name",
                ),
                onChanged: (value) { _newCocktailName = value; },
                validator: Validator.stringValidator,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _addCocktail,
              child: const Text('Add New Cocktail'),
            ),
            const SizedBox(height: 20),
          ],
        )
    );
  }

  void _onCocktailSelected(String? value) {
    isLoading = true;
    _selectedCocktail = Cocktail.fromJsonMap(_cocktailMap[value]);
    isLoading = false;
  }

  void _addCocktail() {
    if (!_formKey.currentState!.validate()) return;
    if (_newCocktailName == null) return;

    var newCocktail = Cocktail(name: _newCocktailName!, description: "description", recipe: "recipe", isEnabled: true);
    _setCocktail(newCocktail);
  }

  void _removeCocktail() {
    if (_selectedCocktail == null) return;

    firebaseController.removeCocktail(_selectedCocktail!).then((value) => _updateCocktailMap());
  }

  void _updateCocktail() {
    if (_selectedCocktail == null) return;

    _setCocktail(_selectedCocktail!);
  }

  void _setCocktail(Cocktail cocktail) {
    firebaseController.setCocktail(cocktail).then((value) => _updateCocktailMap());
  }

  void _updateCocktailMap() {
    isLoading = true;

    firebaseController.getCocktailMap().then((cocktailMap) {
      _cocktailMap = cocktailMap;

      String? firstCocktail = cocktailMap.keys.firstOrNull;
      if (firstCocktail != null) {
        _selectedCocktail = Cocktail.fromJsonMap(cocktailMap[firstCocktail]);
      }

      isLoading = false;
    });
  }
}