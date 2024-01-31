
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:panteon_cocktail_menu/models/bar_settings.dart';

import '../options/firebase_options.dart';

class FirebaseController {

  static const useDatabaseEmulator = false;
  static const emulatorPort = 9000;
  final emulatorHost ='localhost';

  late final FirebaseDatabase _database;
  late final DatabaseReference _adminsRef;
  late final DatabaseReference _barSettingsRef;
  late final DatabaseReference _ordersRef;

  bool _isInitialized = false;
  bool get isInitialized {
    return _isInitialized;
  }

  FirebaseController();

  Future<List<String>> _getAdminList() async {
    final adminSnapshot = await _adminsRef.get();

    if (adminSnapshot.value == null) {
      return <String>[];
    }

    var adminListDynamic = adminSnapshot.value as List<dynamic>;

    var adminList = <String>[];
    for (String admin in adminListDynamic) {
      adminList.add(admin);
    }

    return adminList;
  }

  Future<bool> isUserAdmin(String? email) async {
    if (!_isInitialized) return false;
    if (email == null) return false;

    try {
      var adminList = await _getAdminList();
      return adminList.contains(email);
    } catch (err) {
      return false;
    }
  }

  Future<void> addAdminUser(String? email) async {
    if (!_isInitialized) return;
    if (email == null) return;

     var adminList = await _getAdminList();
    if (adminList.contains(email)) return;

    adminList.add(email);

    await _adminsRef
        .set(adminList);
  }

  Future<void> removeAdminUser(String? email) async {
    if (!_isInitialized) return;
    if (email == null) return;

    var adminList = await _getAdminList();
    if (!adminList.contains(email)) return;

    adminList.remove(email);

    await _adminsRef
        .set(adminList);
  }

  Future<BarSettings> getBarSettings() async {
    final barSnapshot = await _barSettingsRef.get();
    BarSettings barSettings;

    if (barSnapshot.value == null) {
      barSettings = BarSettings.getDefaultSettings();
      setBarSettings(barSettings);
    }

    var barSettingsMap = barSnapshot.value as Map<String, dynamic>;

    barSettings = BarSettings.fromJson(barSettingsMap);

    return barSettings;
  }

  Future<void> setBarSettings(BarSettings barSettings) async {
    await _barSettingsRef
        .set(barSettings.toJson());
  }

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _database = FirebaseDatabase.instance;
    _adminsRef = _database.ref("cbo_admins");
    _ordersRef = _database.ref("cbo_orders");
    _barSettingsRef = _database.ref("cbo_bar_settings");

    if (useDatabaseEmulator) {
      _database.useDatabaseEmulator(emulatorHost, emulatorPort);
    }

    _isInitialized = true;
  }
}