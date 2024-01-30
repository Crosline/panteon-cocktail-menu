
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../options/firebase_options.dart';

class FirebaseController {

  static const USE_DATABASE_EMULATOR = false;
  static const emulatorPort = 9000;
  final emulatorHost ='localhost';

  FirebaseController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (USE_DATABASE_EMULATOR) {
      FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
    }
  }
}