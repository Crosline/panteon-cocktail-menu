import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/controllers/navigation_controller.dart';

import '../main.dart';
import '../models/account_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late bool _loading;
  late StreamSubscription<AccountData?> _onAccountChangeSubscription;

  void _routeToHomePage() => NavigationController.push(context, MyHomePage());

  @override
  void initState() {
    _loading = true;

    if (!signInController.isInitialized) {
      signInController.initialize().then((value) {
        if (signInController.currentUser == null) {
          signInController.trySignInSilent();
        }
        setState(() {
          _loading = false;
        });
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    _onAccountChangeSubscription = signInController.onUserChanged
        .listen((AccountData? account) async {

          if (account != null) {
            _loading = false;
            _routeToHomePage();
        }
    });

    super.initState();
  }

  @override
  void dispose() {
    _onAccountChangeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!_loading) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
          signInController.signIn();

          setState(() {
            _loading = true;
          });
        },
          child: const Text("Sign In"),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());

    }}
}