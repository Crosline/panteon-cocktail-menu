import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../options/google_options.dart';

class SignInController {

  final StreamController<GoogleSignInAccount?> _currentUserController =
  StreamController<GoogleSignInAccount?>.broadcast();

  late final GoogleSignIn googleSignInOptions;

  Stream<GoogleSignInAccount?> get onUserChanged {
    return _currentUserController.stream;
  }

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser {
    return _currentUser;
  }

  SignInController() {
    googleSignInOptions = DefaultGoogleOptions.currentPlatform;
    _initialize();
  }

  void trySignInSilent() {
    DefaultGoogleOptions.currentPlatform.signInSilently();
  }

  Future<void> signIn() async {
    try {
      await DefaultGoogleOptions.currentPlatform.signIn();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _initialize() {
    DefaultGoogleOptions.currentPlatform.onCurrentUserChanged
        .listen(_onAccountDataChanged);
  }

  void _onAccountDataChanged(GoogleSignInAccount? account) {
    _currentUser = account;

    if (_currentUserController.hasListener) {
      _currentUserController.add(account);
    }
  }
}