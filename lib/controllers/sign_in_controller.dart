import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/account_data.dart';
import '../options/google_options.dart';

class SignInController {

  final StreamController<AccountData?> _currentUserController =
  StreamController<AccountData?>.broadcast();

  late final GoogleSignIn googleSignInOptions;

  Stream<AccountData?> get onUserChanged {
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

  void _onAccountDataChanged(GoogleSignInAccount? googleAccount) {
    _currentUser = googleAccount;

    AccountData account = AccountData(googleAccount?.id, googleAccount?.photoUrl, googleAccount?.email, googleAccount?.displayName);

    if (_currentUserController.hasListener) {
      _currentUserController.add(account);
    }
  }

  void signOut() {
    googleSignInOptions.signOut();
  }
}