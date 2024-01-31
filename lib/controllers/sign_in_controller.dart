import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_data.dart';
import '../options/google_options.dart';

class SignInController {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final StreamController<AccountData?> _currentUserController =
  StreamController<AccountData?>.broadcast();

  late final GoogleSignIn googleSignInOptions;

  Stream<AccountData?> get onUserChanged {
    return _currentUserController.stream;
  }

  AccountData? _currentUser;
  AccountData? get currentUser {
    return _currentUser;
  }

  bool _isInitialized = false;
  bool get isInitialized {
    return _isInitialized;
  }

  SignInController() {
    googleSignInOptions = DefaultGoogleOptions.currentPlatform;
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

  Future<void> initialize() async {

    final SharedPreferences prefs = await _prefs;

    final String? accountId = prefs.getString("ptn_accountId");

    if (accountId != null) {

      final String accountEmail = prefs.getString("ptn_accountEmail")!;
      final String accountName = prefs.getString("ptn_accountName")!;
      final String accountPhotoURI = prefs.getString("ptn_accountPhotoURI")!;

      AccountData account = AccountData(accountId, accountPhotoURI, accountEmail, accountName);
      _broadcastNewAccount(account);
    }

    DefaultGoogleOptions.currentPlatform.onCurrentUserChanged
        .listen(_onAccountDataChanged);

    _isInitialized = true;
  }

  _onAccountDataChanged(GoogleSignInAccount? googleAccount) {
    AccountData account = AccountData(googleAccount?.id, googleAccount?.photoUrl, googleAccount?.email, googleAccount?.displayName);
    _broadcastNewAccount(account);

    _setAccountPrefs(account);
  }

  void _broadcastNewAccount(AccountData? account) {
    _currentUser = account;

    if (_currentUserController.hasListener) {
      _currentUserController.add(account);
    }
  }

  Future<void> _setAccountPrefs(AccountData? account) async {
    final SharedPreferences prefs = await _prefs;

    if (account == null || account?.id == null) {
      prefs.remove("ptn_accountId");
      prefs.remove("ptn_accountEmail");
      prefs.remove("ptn_accountName");
      prefs.remove("ptn_accountPhotoURI");
      return;
    }

    prefs.setString("ptn_accountId", account.id!);
    prefs.setString("ptn_accountEmail", account.email!);
    prefs.setString("ptn_accountName", account.displayName!);
    prefs.setString("ptn_accountPhotoURI", account.photoUrl!);
  }

  void signOut() {
    googleSignInOptions.signOut();
    _setAccountPrefs(null);
  }
}