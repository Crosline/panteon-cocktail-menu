import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:panteon_cocktail_menu/main.dart';
import 'package:panteon_cocktail_menu/models/bar_settings.dart';
import 'package:panteon_cocktail_menu/models/cocktail.dart';
import 'package:http/http.dart' as http;

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
    var orderSnapshot = await _getOrderSnapshot(order);

    if (orderSnapshot == null) return;

    order.status = status;
    await orderSnapshot.ref.set(order.toJson());
  }

  Future<void> removeOrder(Order order) async {
    var orderSnapshot = await _getOrderSnapshot(order);

    if (orderSnapshot == null) return;

    await orderSnapshot.ref.remove();
  }

  Future<DataSnapshot?> _getOrderSnapshot(Order order) async {
    final orderSnapshot = await _ordersRef.get();

    for (var dataSnapshot in orderSnapshot.children) {
      Map<String, dynamic> orderInstance = dataSnapshot.value as Map<String, dynamic>;
      var currentOrder = Order.fromJson(orderInstance);
      if (currentOrder.equals(order)) {
        return dataSnapshot;
      }
    }

    return null;
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

    _initializeMessaging();

    _isInitialized = true;
  }

  void onOrdersRefChanged(DatabaseEvent _) {
    getAllOrders().then((orderList) => {
      if (_currentOrderStream.hasListener)
          _currentOrderStream.add(orderList)
    });
  }

  void _initializeMessaging() async {
    var firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: true,
    );
    print("trying get apnsToken");
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      print("apnsToken: $apnsToken");
    }
    print("trying get token");
    var token = await _getNotificationToken();
    if (token != null) {
      _saveNotificationToken(token);
      print("token: $token");
    }
  }


  Future<String?> _getNotificationToken() async {
    var token = FirebaseMessaging.instance.getToken(vapidKey: "BBQYc2aA4luFXTQz95UIjjpprXOfyM_uBQUFbTJx6kP6KdcSaBmzQFyy55wKS7dnyKXb6SoHtKAttBNvahQ5r6Y");
    return token;
  }

  void _saveNotificationToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc(signInController.currentUser!.displayName).set({
      'token' : token,
    });
  }

  void sendPushMessageTo(String usernameToSend, String body, String title) async {
    var snap = await FirebaseFirestore.instance.collection("UserTokens").doc(usernameToSend).get();
    String token = snap['token'];

    try {
      var s = http.post(
        (Uri.parse('https://fcm.googleapis.com/fcm/send')),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AIzaSyBU_R9wMkv1JkKHmH2wwHQ75dEIfZvdq6Y'
        },
        body: jsonEncode(
          <String, dynamic> {
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          }
        )
      );
    }
    catch (e) {
      // Something went wrong
      if (kDebugMode) {
        print("ERROR SENDING PUSH NOTIFICATION "
            "\nUSER: $usernameToSend "
            "\nBODY: $body\nTITLE: $title");
      }
    }
  }
}
