import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/widgets/loading_widget.dart';

import '../../main.dart';
import '../../models/bar_settings.dart';
import '../../utils/validator.dart';

class BarSettingsWidget extends StatefulWidget {
  const BarSettingsWidget({super.key});

  @override
  LoadingWidgetState<BarSettingsWidget> createState() => _BarSettingsWidgetState();
}

class _BarSettingsWidgetState extends LoadingWidgetState<BarSettingsWidget> {
  late BarSettings barSettings = BarSettings.getDefaultSettings();

  @override
  void initState() {
    firebaseController.getBarSettings().then((newBarSettings) {
      barSettings = newBarSettings;
      // setState(() {
        isLoading = false;
      // });
    });

    super.initState();
  }

  void _submit() {
    // setState(() {
      isLoading = true;
    // });

    firebaseController.setBarSettings(barSettings).then((newBarSettings) {
      // setState(() {
        isLoading = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildLoading(
      Column(
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
            validator: Validator.stringValidator,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: barSettings.isOpen,
                onChanged: (value) { setState(() {
                  barSettings.isOpen = value!;
                }); },
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
        ],
      )
    );
  }
}