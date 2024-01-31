
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../options/firebase_options.dart';

class FirebaseController {

  static const USE_DATABASE_EMULATOR = false;
  static const emulatorPort = 9000;
  final emulatorHost ='localhost';

  late final FirebaseDatabase _database;
  late final DatabaseReference _orders;

  bool _isInitialized = false;
  bool get isInitialized {
    return _isInitialized;
  }

  FirebaseController();

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _database = FirebaseDatabase.instance;
    _orders = _database.ref("cbo_orders");

    if (USE_DATABASE_EMULATOR) {
      _database.useDatabaseEmulator(emulatorHost, emulatorPort);
    }

    _isInitialized = true;
  }
}