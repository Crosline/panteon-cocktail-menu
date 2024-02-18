import 'cocktail.dart';

class Order {
  late Map<Cocktail, int>? cocktails;
  late DateTime? orderTime;
  String status = "pending";
  String accountName;

  Order(
      {required this.accountName,
      this.orderTime,
      this.cocktails,
      this.status = "pending"});

  Map<String, dynamic> toJson() {
    return {
      "cocktails": _serializeCocktailMap(cocktails),
      "orderTime": orderTime!.millisecondsSinceEpoch,
      "account": accountName,
      "status": status
    };
  }

  static Map<dynamic, dynamic> _serializeCocktailMap(
      Map<Cocktail, int>? cocktails) {
    Map<dynamic, dynamic> cocktailMap = <dynamic, dynamic>{};
    if (cocktails == null) return cocktailMap;

    for (Cocktail cocktail in cocktails.keys) {
      cocktailMap[cocktail.toJson()] = cocktails[cocktail];
    }

    return cocktailMap;
  }

  static Map<Cocktail, int> _deserializeCocktailMap(
      Map<dynamic, dynamic>? cocktails) {
    Map<Cocktail, int> cocktailMap = <Cocktail, int>{};
    if (cocktails == null) return cocktailMap;

    for (String cocktail in cocktails.keys) {
      cocktailMap[Cocktail.fromJson(cocktail)] = cocktails[cocktail];
    }

    return cocktailMap;
  }

  static Order fromJson(Map<String, dynamic> map) {
    var order = Order(
        accountName: map["account"],
        status: map["status"],
        orderTime: DateTime.fromMillisecondsSinceEpoch(map["orderTime"]),
        cocktails: _deserializeCocktailMap(map["cocktails"]));

    return order;
  }
}
