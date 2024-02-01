import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/utils/validator.dart';

import '../../main.dart';
import '../loading_widget.dart';

class AdminSettingsWidget extends StatefulWidget {
  const AdminSettingsWidget({super.key});

  @override
  LoadingWidgetState<AdminSettingsWidget> createState() => _AdminSettingsWidgetState();
}

class _AdminSettingsWidgetState extends LoadingWidgetState<AdminSettingsWidget> {
  String? _adminToUpdate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }
  void _setAdminToUpdate(String? value) {
    _adminToUpdate = value;
  }

  void _updateAdmin(bool isAdd) {
    if (!_formKey.currentState!.validate()) return;

    if (_adminToUpdate == signInController.currentUser!.email) return;

    isLoading = true;

    if (isAdd) {
      firebaseController.addAdminUser(_adminToUpdate).then((value) => {
        isLoading = false
      });
    } else {
      firebaseController.removeAdminUser(_adminToUpdate).then((value) => {
        isLoading = false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildLoading(
      Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'example@panteon.games',
                labelText: "CBO Email",
              ),
              onChanged: _setAdminToUpdate,
              validator: Validator.stringValidator,
            ),
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
        ],
      )
    );
  }
}