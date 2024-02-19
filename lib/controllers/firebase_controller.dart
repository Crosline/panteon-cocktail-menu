import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:panteon_cocktail_menu/models/bar_settings.dart';
import 'package:panteon_cocktail_menu/models/cocktail.dart';

import '../models/order.dart';
import '../options/firebase_options.dart';

class FirebaseController {
  static const useDatabaseEmulator = false;
  static const emulatorPort = 9000;
  final emulatorHost = 'localhost';

  late final FirebaseDatabase _database;
  late final DatabaseReference _adminsRef;
  late final DatabaseReference _barSettingsRef;
  late final DatabaseReference _ordersRef;
  late final DatabaseReference _cocktailDbRef;

  final StreamController<List<Order>> _currentOrderStream =
      StreamController<List<Order>>.broadcast();

  Stream<List<Order>> get onOrderChanged {
    return _currentOrderStream.stream;
  }

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

    await _adminsRef.set(adminList);
  }

  Future<void> removeAdminUser(String? email) async {
    if (!_isInitialized) return;
    if (email == null) return;

    var adminList = await _getAdminList();
    if (!adminList.contains(email)) return;

    adminList.remove(email);

    await _adminsRef.set(adminList);
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
    await _barSettingsRef.set(barSettings.toJson());
  }

  Future<void> setCocktail(Cocktail cocktail) async {
    Map<String, dynamic> cocktailMap = await getCocktailMap();

    cocktailMap[cocktail.name] = cocktail.toJsonMap();

    await _cocktailDbRef.set(cocktailMap);
  }

  Future<void> removeCocktail(Cocktail cocktail) async {
    Map<String, dynamic> cocktailMap = await getCocktailMap();

    if (cocktailMap.containsKey(cocktail.name)) {
      cocktailMap.remove(cocktail.name);
    }

    await _cocktailDbRef.set(cocktailMap);
  }

  Future<Map<String, dynamic>> getCocktailMap() async {
    var cocktailDbSnapshot = await _cocktailDbRef.get();

    Map<String, dynamic> cocktailMap;
    if (cocktailDbSnapshot.value == null) {
      cocktailMap = <String, dynamic>{};
    } else {
      cocktailMap = cocktailDbSnapshot.value as Map<String, dynamic>;
    }

    return cocktailMap;
  }

  Future<void> addNewOrder(Order order) async {
    await _ordersRef.push().set(order.toJson());
  }

  Future<void> updateOrderStatus(Order order, String status) async {
    final orderSnapshot = await _ordersRef.get();

    for (var dataSnapshot in orderSnapshot.children) {
      Map<String, dynamic> orderInstance = dataSnapshot.value as Map<String, dynamic>;
      var currentOrder = Order.fromJson(orderInstance);
      if (currentOrder.equals(order)) {
        order.status = status;
        dataSnapshot.ref.set(order.toJson());
        break;
      }
    }
  }

  Future<List<Order>> getAllOrders() async {
    final orderSnapshot = await _ordersRef.get();

    return getAllOrdersFromSnapshot(orderSnapshot);
  }

  List<Order> getAllOrdersFromSnapshot(final DataSnapshot orderSnapshot) {
    List<Order> orders = <Order>[];

    if (orderSnapshot.value == null) return orders;

    var ordersMap = orderSnapshot.value as Map<String, dynamic>;

    for (Map<String, dynamic> orderInstance in ordersMap.values) {
      orders.add(Order.fromJson(orderInstance));
    }

    return orders;
  }

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _database = FirebaseDatabase.instance;
    _adminsRef = _database.ref("cbo_admins");

    _ordersRef = _database.ref("cbo_orders");
    _ordersRef.onChildChanged.listen(onOrdersRefChanged);
    _ordersRef.onChildAdded.listen(onOrdersRefChanged);
    _ordersRef.onChildRemoved.listen(onOrdersRefChanged);

    _barSettingsRef = _database.ref("cbo_bar_settings");
    _cocktailDbRef = _database.ref("cbo_cocktails");

    if (useDatabaseEmulator) {
      _database.useDatabaseEmulator(emulatorHost, emulatorPort);
    }

    _isInitialized = true;
  }

  void onOrdersRefChanged(DatabaseEvent _) {
    getAllOrders().then((orderList) => {
      if (_currentOrderStream.hasListener)
          _currentOrderStream.add(orderList)
    });
  }
}
