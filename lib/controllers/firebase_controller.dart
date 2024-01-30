
import 'dart:async';
import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../options/firebase_options.dart';

class FirebaseController {

  final StreamController _streamController =
  StreamController.broadcast();
  Stream get onInitialized {
    return _streamController.stream;
  }

  static const USE_DATABASE_EMULATOR = false;
  static const emulatorPort = 9000;
  final emulatorHost ='localhost';

  late final FirebaseDatabase _database;
  late final DatabaseReference _admins;

  late bool _initialized;

  FirebaseController() {
    _initialized = false;
    _initialize();
  }

  Future<List<String>> _getAdminList() async {
    final adminSnapshot = await _admins.get();

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

  Future<bool> isUserAdmin(String? id) async {
    if (!_initialized) return false;
    if (id == null) return false;

    try {
      var adminList = await _getAdminList();
      return adminList.contains(id);
    } catch (err) {
      return false;
    }
  }

  Future<void> addAdminUser(String? id) async {
    if (!_initialized) return;
    if (id == null) return;

     var adminList = await _getAdminList();
    if (adminList.contains("id")) return;

    adminList.add(id);

    await _admins
        .set(adminList);
  }

  Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _database = FirebaseDatabase.instance;
    _admins = _database.ref("cbo_admins");

    if (USE_DATABASE_EMULATOR) {
      _database.useDatabaseEmulator(emulatorHost, emulatorPort);
    }

    _initialized = true;
    if (_streamController.hasListener) {
      _streamController.add(null);
    }
  }
}