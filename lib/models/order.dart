import 'cocktail.dart';

class Order {
  Cocktail cocktail;
  DateTime orderTime;
  String status = "pending";
  String accountName;
  int amount;

  Order({
    required this.accountName,
    required this.orderTime,
    required this.cocktail,
    this.amount = 1,
    this.status = "pending"
  });

  Map<String, dynamic> toJson() {
    return {
      "cocktail" : cocktail.toJsonMap(),
      "orderTime": orderTime!.millisecondsSinceEpoch,
      "account": accountName,
      "amount": amount,
      "status": status
    };
  }

  static Order fromJson(Map<String, dynamic> map) {
    var order = Order(
        accountName: map["account"],
        status: map["status"],
        amount: map["amount"],
        orderTime: DateTime.fromMillisecondsSinceEpoch(map["orderTime"]),
        cocktail: Cocktail.fromJsonMap(map["cocktail"]));

    return order;
  }

  bool equals(Order other) {
    return other.accountName == accountName
        && other.cocktail.name == cocktail.name
        && other.amount == amount
        && (other.orderTime.millisecondsSinceEpoch - orderTime.millisecondsSinceEpoch) < 1000;
  }
}
