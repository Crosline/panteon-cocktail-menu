import 'package:flutter/material.dart';

import '../../main.dart';
import '../loading_widget.dart';

class AdminSettingsWidget extends StatefulWidget {
  const AdminSettingsWidget({super.key});

  @override
  LoadingWidgetState<AdminSettingsWidget> createState() => _AdminSettingsWidgetState();
}

class _AdminSettingsWidgetState extends LoadingWidgetState<AdminSettingsWidget> {
  String? _adminToUpdate;

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
  }
  void _setAdminToUpdate(String? value) {
    _adminToUpdate = value;
  }

  void _updateAdmin(bool isAdd) {
    setState(() {
      isLoading = true;
    });

    if (isAdd) {
      firebaseController.addAdminUser(_adminToUpdate).then((value) => {
        setState(() {
          isLoading = false;
        })
      });
    } else {
      firebaseController.removeAdminUser(_adminToUpdate).then((value) => {
        setState(() {
          isLoading = false;
        })
      });
    }
  }

  String? _validate(String? value) {
  }

  @override
  Widget build(BuildContext context) {
    return buildLoading(
      Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'example@panteon.games',
              labelText: "CBO Email",
            ),
            onChanged: _setAdminToUpdate,
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
        ],
      )
    );
  }
}